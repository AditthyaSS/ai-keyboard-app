import '../constants/app_constants.dart';

/// Input validation utility functions
class Validators {
  Validators._();

  /// Validates if an API key has valid format
  static String? validateApiKey(String? value, {String? type}) {
    if (value == null || value.trim().isEmpty) {
      return '${type ?? 'API'} key is required';
    }
    if (value.trim().length < AppConstants.minApiKeyLength) {
      return '${type ?? 'API'} key must be at least ${AppConstants.minApiKeyLength} characters';
    }
    return null;
  }

  /// Validates if text is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates if text is within allowed length
  static String? validateTextLength(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter some text';
    }
    if (value.length > AppConstants.maxTextLength) {
      return 'Text is too long (max ${AppConstants.maxTextLength} characters)';
    }
    return null;
  }

  /// Checks if text exceeds maximum length
  static bool isTextTooLong(String? value) {
    return value != null && value.length > AppConstants.maxTextLength;
  }

  /// Validates both API keys are present and valid
  static bool areApiKeysValid(String? geminiKey, String? openAiKey) {
    return validateApiKey(geminiKey) == null && 
           validateApiKey(openAiKey) == null;
  }
}
