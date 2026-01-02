/// Indian language configuration
class IndianLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String emoji;

  const IndianLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.emoji,
  });

  String get displayName => '$emoji $nativeName';
}

/// Available Indian languages for the app
class IndianLanguages {
  IndianLanguages._();

  static const List<IndianLanguage> all = [
    IndianLanguage(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिंदी',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'bn',
      name: 'Bengali',
      nativeName: 'বাংলা',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'gu',
      name: 'Gujarati',
      nativeName: 'ગુજરાતી',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'ml',
      name: 'Malayalam',
      nativeName: 'മലയാളം',
      emoji: '🇮🇳',
    ),
    IndianLanguage(
      code: 'pa',
      name: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
      emoji: '🇮🇳',
    ),
  ];

  static const IndianLanguage defaultLanguage = IndianLanguage(
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिंदी',
    emoji: '🇮🇳',
  );

  static IndianLanguage getByCode(String code) {
    return all.firstWhere(
      (lang) => lang.code == code,
      orElse: () => defaultLanguage,
    );
  }
}
