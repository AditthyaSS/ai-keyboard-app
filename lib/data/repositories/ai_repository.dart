import '../../core/constants/indian_languages.dart';
import '../../core/constants/tone_presets.dart';
import '../models/text_suggestion.dart';
import '../models/translation_result.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';
import '../services/translation_service.dart';

/// Repository that aggregates all AI services
class AIRepository {
  final StorageService _storageService;
  final GeminiService _geminiService;
  final TranslationService _translationService;

  AIRepository({
    StorageService? storageService,
    GeminiService? geminiService,
    TranslationService? translationService,
  })  : _storageService = storageService ?? StorageService(),
        _geminiService = geminiService ?? GeminiService(),
        _translationService = translationService ?? TranslationService();

  // Initialization
  
  Future<void> initializeServices() async {
    final geminiKey = await _storageService.getGeminiApiKey();

    if (geminiKey != null && geminiKey.isNotEmpty) {
      _geminiService.initialize(geminiKey);
    }
  }

  Future<bool> hasValidApiKey() async {
    return await _storageService.hasApiKey();
  }

  // Storage operations
  
  Future<void> saveApiKey(String geminiKey) async {
    await _storageService.saveGeminiApiKey(geminiKey);
    _geminiService.initialize(geminiKey);
  }

  Future<String?> getGeminiApiKey() => _storageService.getGeminiApiKey();

  Future<void> saveSelectedLanguage(String code) => 
      _storageService.saveSelectedLanguage(code);
  
  Future<String> getSelectedLanguage() => 
      _storageService.getSelectedLanguage();

  Future<void> clearAllData() async {
    await _storageService.clearAllData();
  }

  // Grammar checking
  
  Future<TextSuggestion> checkGrammar({
    required String text,
    required IndianLanguage language,
  }) async {
    return await _geminiService.checkGrammar(
      text: text,
      languageName: language.name,
    );
  }

  // Tone transformation
  
  Future<String> transformTone({
    required String text,
    required IndianLanguage language,
    required TonePreset tone,
  }) async {
    return await _geminiService.transformTone(
      text: text,
      languageName: language.name,
      tone: tone,
    );
  }

  // Translation
  
  Future<TranslationResult> translate({
    required String text,
    required IndianLanguage sourceLanguage,
    required IndianLanguage targetLanguage,
  }) async {
    // Using Gemini for translation (more accurate for Indian languages)
    final translatedText = await _geminiService.translateText(
      text: text,
      sourceLanguage: sourceLanguage.name,
      targetLanguage: targetLanguage.name,
    );
    
    return TranslationResult(
      originalText: text,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage.name,
      targetLanguage: targetLanguage.name,
    );
  }

  Future<TranslationResult> translateWithGoogleApi({
    required String text,
    required IndianLanguage sourceLanguage,
    required IndianLanguage targetLanguage,
  }) async {
    return await _translationService.translate(
      text: text,
      sourceLanguageCode: sourceLanguage.code,
      targetLanguageCode: targetLanguage.code,
      sourceLanguageName: sourceLanguage.name,
      targetLanguageName: targetLanguage.name,
    );
  }
}
