import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/indian_languages.dart';
import '../../data/repositories/ai_repository.dart';
import 'api_key_provider.dart';

/// Notifier for language selection
class LanguageNotifier extends StateNotifier<IndianLanguage> {
  final AIRepository _repository;

  LanguageNotifier(this._repository) : super(IndianLanguages.defaultLanguage);

  /// Load saved language preference
  Future<void> loadSavedLanguage() async {
    final code = await _repository.getSelectedLanguage();
    state = IndianLanguages.getByCode(code);
  }

  /// Change selected language
  Future<void> setLanguage(IndianLanguage language) async {
    state = language;
    await _repository.saveSelectedLanguage(language.code);
  }

  /// Get language by code
  IndianLanguage getLanguageByCode(String code) {
    return IndianLanguages.getByCode(code);
  }
}

// Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, IndianLanguage>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return LanguageNotifier(repository);
});

// List of all available languages
final availableLanguagesProvider = Provider<List<IndianLanguage>>((ref) {
  return IndianLanguages.all;
});
