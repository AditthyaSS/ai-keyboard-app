import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/services/storage_service.dart';

/// State for API key
class ApiKeyState {
  final String? geminiKey;
  final bool isLoading;
  final bool hasValidKey;
  final String? error;

  const ApiKeyState({
    this.geminiKey,
    this.isLoading = false,
    this.hasValidKey = false,
    this.error,
  });

  ApiKeyState copyWith({
    String? geminiKey,
    bool? isLoading,
    bool? hasValidKey,
    String? error,
  }) {
    return ApiKeyState(
      geminiKey: geminiKey ?? this.geminiKey,
      isLoading: isLoading ?? this.isLoading,
      hasValidKey: hasValidKey ?? this.hasValidKey,
      error: error,
    );
  }
}

/// Notifier for managing API key state
class ApiKeyNotifier extends StateNotifier<ApiKeyState> {
  final AIRepository _repository;

  ApiKeyNotifier(this._repository) : super(const ApiKeyState());

  /// Check if API key exists
  Future<void> checkApiKey() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final hasKey = await _repository.hasValidApiKey();
      if (hasKey) {
        final geminiKey = await _repository.getGeminiApiKey();
        await _repository.initializeServices();
        state = state.copyWith(
          geminiKey: geminiKey,
          hasValidKey: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(hasValidKey: false, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load API key',
      );
    }
  }

  /// Save API key
  Future<bool> saveApiKey(String geminiKey) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.saveApiKey(geminiKey.trim());
      state = state.copyWith(
        geminiKey: geminiKey.trim(),
        hasValidKey: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save API key',
      );
      return false;
    }
  }

  /// Clear API key
  Future<void> clearApiKey() async {
    await _repository.clearAllData();
    state = const ApiKeyState();
  }
}

// Providers

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository();
});

final apiKeyProvider = StateNotifierProvider<ApiKeyNotifier, ApiKeyState>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return ApiKeyNotifier(repository);
});
