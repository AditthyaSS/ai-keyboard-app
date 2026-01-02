/// Model representing a translation result
class TranslationResult {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslationResult({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  factory TranslationResult.empty() {
    return const TranslationResult(
      originalText: '',
      translatedText: '',
      sourceLanguage: '',
      targetLanguage: '',
    );
  }

  Map<String, dynamic> toJson() => {
    'originalText': originalText,
    'translatedText': translatedText,
    'sourceLanguage': sourceLanguage,
    'targetLanguage': targetLanguage,
  };

  TranslationResult copyWith({
    String? originalText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
  }) {
    return TranslationResult(
      originalText: originalText ?? this.originalText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }
}
