/// App-wide constants for Smart Keyboard Assistant
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Smart Keyboard';
  static const String appVersion = '1.0.0';

  // Timing Constants
  static const int grammarCheckDebounceMs = 800;
  static const int loadingIndicatorDelayMs = 500;
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;

  // Text Limits
  static const int maxTextLength = 5000;
  static const int minApiKeyLength = 20;

  // Storage Keys
  static const String geminiApiKeyKey = 'gemini_api_key';
  static const String selectedLanguageKey = 'selected_language';

  // API Key Help URL
  static const String geminiApiKeyUrl = 'https://makersuite.google.com/app/apikey';
}
