import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/tone_presets.dart';
import '../../data/models/text_suggestion.dart';
import '../../data/repositories/ai_repository.dart';
import 'api_key_provider.dart';
import 'language_provider.dart';

/// State for text editor
class TextEditorState {
  final String text;
  final TextSuggestion? suggestion;
  final bool isCheckingGrammar;
  final bool isTransformingTone;
  final String? transformedText;
  final String? error;

  const TextEditorState({
    this.text = '',
    this.suggestion,
    this.isCheckingGrammar = false,
    this.isTransformingTone = false,
    this.transformedText,
    this.error,
  });

  TextEditorState copyWith({
    String? text,
    TextSuggestion? suggestion,
    bool? isCheckingGrammar,
    bool? isTransformingTone,
    String? transformedText,
    String? error,
    bool clearSuggestion = false,
    bool clearTransformedText = false,
    bool clearError = false,
  }) {
    return TextEditorState(
      text: text ?? this.text,
      suggestion: clearSuggestion ? null : (suggestion ?? this.suggestion),
      isCheckingGrammar: isCheckingGrammar ?? this.isCheckingGrammar,
      isTransformingTone: isTransformingTone ?? this.isTransformingTone,
      transformedText: clearTransformedText ? null : (transformedText ?? this.transformedText),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for text editor state
class TextEditorNotifier extends StateNotifier<TextEditorState> {
  final AIRepository _repository;
  final Ref _ref;
  Timer? _debounceTimer;

  TextEditorNotifier(this._repository, this._ref) : super(const TextEditorState());

  /// Update text and trigger debounced grammar check
  void updateText(String text) {
    state = state.copyWith(
      text: text,
      clearSuggestion: true,
      clearError: true,
    );

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Don't check if text is too short
    if (text.trim().length < 3) return;

    // Debounced grammar check
    _debounceTimer = Timer(
      const Duration(milliseconds: AppConstants.grammarCheckDebounceMs),
      () => checkGrammar(),
    );
  }

  /// Check grammar manually
  Future<void> checkGrammar() async {
    if (state.text.trim().isEmpty) {
      state = state.copyWith(clearSuggestion: true);
      return;
    }

    state = state.copyWith(isCheckingGrammar: true, clearError: true);

    try {
      final language = _ref.read(languageProvider);
      final suggestion = await _repository.checkGrammar(
        text: state.text,
        language: language,
      );
      state = state.copyWith(
        suggestion: suggestion,
        isCheckingGrammar: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCheckingGrammar: false,
        error: 'Failed to check grammar: ${e.toString()}',
      );
    }
  }

  /// Apply grammar correction
  void applyCorrectedText() {
    if (state.suggestion != null && state.suggestion!.hasErrors) {
      state = state.copyWith(
        text: state.suggestion!.corrected,
        clearSuggestion: true,
      );
    }
  }

  /// Apply single fix
  void applySingleFix(int index) {
    if (state.suggestion == null || index >= state.suggestion!.errors.length) {
      return;
    }

    final error = state.suggestion!.errors[index];
    final newText = state.text.replaceFirst(error.original, error.suggestion);
    
    // Create updated errors list without the fixed error
    final updatedErrors = List.of(state.suggestion!.errors)..removeAt(index);
    
    state = state.copyWith(
      text: newText,
      suggestion: state.suggestion!.copyWith(
        errors: updatedErrors,
        hasErrors: updatedErrors.isNotEmpty,
      ),
    );
  }

  /// Transform text tone
  Future<void> transformTone(TonePreset tone) async {
    if (state.text.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter some text first');
      return;
    }

    state = state.copyWith(isTransformingTone: true, clearError: true);

    try {
      final language = _ref.read(languageProvider);
      final transformed = await _repository.transformTone(
        text: state.text,
        language: language,
        tone: tone,
      );
      state = state.copyWith(
        transformedText: transformed,
        isTransformingTone: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTransformingTone: false,
        error: 'Failed to transform tone: ${e.toString()}',
      );
    }
  }

  /// Apply transformed text
  void applyTransformedText() {
    if (state.transformedText != null) {
      state = state.copyWith(
        text: state.transformedText,
        clearTransformedText: true,
        clearSuggestion: true,
      );
    }
  }

  /// Clear transformed text
  void clearTransformedText() {
    state = state.copyWith(clearTransformedText: true);
  }

  /// Append transcribed text
  void appendTranscribedText(String transcribedText) {
    final newText = state.text.isEmpty 
        ? transcribedText 
        : '${state.text} $transcribedText';
    updateText(newText);
  }

  /// Clear all text
  void clearText() {
    _debounceTimer?.cancel();
    state = const TextEditorState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

// Provider
final textEditorProvider = StateNotifierProvider<TextEditorNotifier, TextEditorState>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return TextEditorNotifier(repository, ref);
});
