/// Model representing a single grammar/spelling error
class TextError {
  final String type; // 'grammar' or 'spelling'
  final String original;
  final String suggestion;
  final int? position;

  const TextError({
    required this.type,
    required this.original,
    required this.suggestion,
    this.position,
  });

  factory TextError.fromJson(Map<String, dynamic> json) {
    return TextError(
      type: json['type'] as String? ?? 'grammar',
      original: json['original'] as String? ?? '',
      suggestion: json['suggestion'] as String? ?? '',
      position: json['position'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'original': original,
    'suggestion': suggestion,
    'position': position,
  };
}

/// Model representing grammar check result with suggestions
class TextSuggestion {
  final bool hasErrors;
  final String original;
  final String corrected;
  final List<TextError> errors;

  const TextSuggestion({
    required this.hasErrors,
    required this.original,
    required this.corrected,
    required this.errors,
  });

  factory TextSuggestion.empty() {
    return const TextSuggestion(
      hasErrors: false,
      original: '',
      corrected: '',
      errors: [],
    );
  }

  factory TextSuggestion.fromJson(Map<String, dynamic> json) {
    final errorsList = (json['errors'] as List<dynamic>?)
        ?.map((e) => TextError.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];

    return TextSuggestion(
      hasErrors: json['has_errors'] as bool? ?? false,
      original: json['original'] as String? ?? '',
      corrected: json['corrected'] as String? ?? '',
      errors: errorsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'has_errors': hasErrors,
    'original': original,
    'corrected': corrected,
    'errors': errors.map((e) => e.toJson()).toList(),
  };

  TextSuggestion copyWith({
    bool? hasErrors,
    String? original,
    String? corrected,
    List<TextError>? errors,
  }) {
    return TextSuggestion(
      hasErrors: hasErrors ?? this.hasErrors,
      original: original ?? this.original,
      corrected: corrected ?? this.corrected,
      errors: errors ?? this.errors,
    );
  }
}
