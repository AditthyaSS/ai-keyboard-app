import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/translation_result.dart';

/// Service for translation between Indian languages
class TranslationService {
  /// Translate text between languages using Google Translate API
  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
    required String sourceLanguageName,
    required String targetLanguageName,
  }) async {
    if (text.trim().isEmpty) {
      return TranslationResult.empty();
    }

    try {
      // Use the free Google Translate API endpoint
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single'
        '?client=gtx'
        '&sl=$sourceLanguageCode'
        '&tl=$targetLanguageCode'
        '&dt=t'
        '&q=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Extract translated text from response
        final translatedParts = <String>[];
        if (data is List && data.isNotEmpty && data[0] is List) {
          for (final part in data[0]) {
            if (part is List && part.isNotEmpty && part[0] is String) {
              translatedParts.add(part[0] as String);
            }
          }
        }

        final translatedText = translatedParts.join('');
        
        return TranslationResult(
          originalText: text,
          translatedText: translatedText.isEmpty ? text : translatedText,
          sourceLanguage: sourceLanguageName,
          targetLanguage: targetLanguageName,
        );
      } else {
        throw Exception('Translation failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to translate: $e');
    }
  }
}
