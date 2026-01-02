import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Service for secure storage of API keys and preferences
class StorageService {
  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // API Key Storage (Secure)
  
  Future<void> saveGeminiApiKey(String key) async {
    await _secureStorage.write(
      key: AppConstants.geminiApiKeyKey,
      value: key,
    );
  }

  Future<String?> getGeminiApiKey() async {
    return await _secureStorage.read(key: AppConstants.geminiApiKeyKey);
  }

  Future<bool> hasApiKey() async {
    final geminiKey = await getGeminiApiKey();
    return geminiKey != null && geminiKey.isNotEmpty;
  }

  Future<void> deleteApiKey() async {
    await _secureStorage.delete(key: AppConstants.geminiApiKeyKey);
  }

  // Language Preference Storage (SharedPreferences)
  
  Future<void> saveSelectedLanguage(String languageCode) async {
    await _initPrefs();
    await _prefs!.setString(AppConstants.selectedLanguageKey, languageCode);
  }

  Future<String> getSelectedLanguage() async {
    await _initPrefs();
    return _prefs!.getString(AppConstants.selectedLanguageKey) ?? 'hi';
  }

  // Clear all data
  
  Future<void> clearAllData() async {
    await _secureStorage.deleteAll();
    await _initPrefs();
    await _prefs!.clear();
  }
}
