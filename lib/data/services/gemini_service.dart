import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/tone_presets.dart';
import '../models/text_suggestion.dart';

/// Service for Google Gemini API integration using HTTP
class GeminiService {
  String? _apiKey;
  String? _availableModel;
  
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  /// Initialize the Gemini service with API key
  void initialize(String apiKey) {
    _apiKey = apiKey;
    _availableModel = null; // Reset model discovery
  }

  bool get isInitialized => _apiKey != null && _apiKey!.isNotEmpty;

  /// Discover available models for this API key
  Future<String> _discoverModel() async {
    if (_availableModel != null) return _availableModel!;
    
    // Try to list available models
    final url = Uri.parse('$_baseUrl/models?key=$_apiKey');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List?;
        
        if (models != null && models.isNotEmpty) {
          // Find a suitable text generation model
          for (final model in models) {
            final name = model['name'] as String? ?? '';
            final supportedMethods = model['supportedGenerationMethods'] as List? ?? [];
            
            // Check if this model supports generateContent
            if (supportedMethods.contains('generateContent')) {
              // Extract just the model name (remove 'models/' prefix)
              _availableModel = name.replaceFirst('models/', '');
              print('Found available model: $_availableModel');
              return _availableModel!;
            }
          }
        }
      }
    } catch (e) {
      print('Model discovery failed: $e');
    }
    
    // Fallback to gemini-pro if discovery fails
    _availableModel = 'gemini-pro';
    return _availableModel!;
  }

  /// Make API call to Gemini
  Future<String> _generateContent(String prompt) async {
    if (!isInitialized) {
      throw Exception('GeminiService not initialized. Call initialize() first.');
    }

    // Discover available model first
    final model = await _discoverModel();
    final url = Uri.parse('$_baseUrl/models/$model:generateContent?key=$_apiKey');
    
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2048,
      }
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'] as String? ?? '';
        }
      }
      return '';
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
      throw Exception('API Error: $errorMessage');
    }
  }

  /// Check grammar and spelling in the given text
  Future<TextSuggestion> checkGrammar({
    required String text,
    required String languageName,
  }) async {
    final prompt = '''
Analyze this text in $languageName for grammar and spelling errors.
Provide corrections in JSON format only, with no additional text or markdown:
{
  "has_errors": true or false,
  "original": "original text",
  "corrected": "corrected text with all fixes applied",
  "errors": [
    {
      "type": "grammar" or "spelling",
      "original": "wrong word or phrase",
      "suggestion": "correct word or phrase",
      "position": start_index_as_number
    }
  ]
}

If there are no errors, return:
{
  "has_errors": false,
  "original": "original text",
  "corrected": "original text",
  "errors": []
}

Text to analyze: $text
''';

    try {
      final responseText = await _generateContent(prompt);
      
      // Extract JSON from response
      final jsonString = _extractJson(responseText);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      
      return TextSuggestion.fromJson(jsonData);
    } catch (e) {
      // Return empty suggestion on error
      return TextSuggestion(
        hasErrors: false,
        original: text,
        corrected: text,
        errors: [],
      );
    }
  }

  /// Transform text to a different tone
  Future<String> transformTone({
    required String text,
    required String languageName,
    required TonePreset tone,
  }) async {
    final prompt = '''
Rewrite this text in $languageName with a ${tone.promptDescription}
Maintain the core meaning but adjust the tone appropriately.
Return ONLY the rewritten text without any explanations, quotes, or metadata.

Original text: $text
''';

    try {
      final response = await _generateContent(prompt);
      return response.trim();
    } catch (e) {
      throw Exception('Failed to transform tone: $e');
    }
  }

  /// Translate text using Gemini
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final prompt = '''
Translate the following text from $sourceLanguage to $targetLanguage.
Return ONLY the translated text without any explanations or metadata.

Text: $text
''';

    try {
      final response = await _generateContent(prompt);
      return response.trim();
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }

  /// Extract JSON from response text (handles markdown code blocks)
  String _extractJson(String text) {
    // Try to find JSON in code blocks first
    final codeBlockPattern = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
    final match = codeBlockPattern.firstMatch(text);
    if (match != null) {
      return match.group(1)!.trim();
    }
    
    // Try to find raw JSON
    final jsonPattern = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonPattern.firstMatch(text);
    if (jsonMatch != null) {
      return jsonMatch.group(0)!;
    }
    
    return text.trim();
  }
}
