import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/text_suggestion.dart';
import '../providers/text_editor_provider.dart';

/// Card widget displaying grammar suggestions
class SuggestionCardWidget extends ConsumerWidget {
  const SuggestionCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(textEditorProvider);
    final suggestion = state.suggestion;

    if (suggestion == null || !suggestion.hasErrors) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.spellcheck,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggestions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${suggestion.errors.length} issue${suggestion.errors.length > 1 ? 's' : ''} found',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(textEditorProvider.notifier).applyCorrectedText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All corrections applied'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Fix All'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Error list
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < suggestion.errors.length; i++)
                      _ErrorItem(
                        error: suggestion.errors[i],
                        onFix: () {
                          ref.read(textEditorProvider.notifier).applySingleFix(i);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(
      begin: 0.1,
      end: 0,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _ErrorItem extends StatelessWidget {
  final TextError error;
  final VoidCallback onFix;

  const _ErrorItem({
    required this.error,
    required this.onFix,
  });

  @override
  Widget build(BuildContext context) {
    final isSpelling = error.type == 'spelling';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Error type indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSpelling 
                  ? Colors.orange.withAlpha(25)
                  : Colors.blue.withAlpha(25),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isSpelling ? 'Spelling' : 'Grammar',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSpelling ? Colors.orange.shade700 : Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Error content
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: error.original,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
                  const TextSpan(text: ' → '),
                  TextSpan(
                    text: error.suggestion,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Fix button
          IconButton(
            icon: Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
            onPressed: onFix,
            tooltip: 'Apply fix',
          ),
        ],
      ),
    );
  }
}
