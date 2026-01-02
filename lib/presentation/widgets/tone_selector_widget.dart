import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/tone_presets.dart';
import '../providers/text_editor_provider.dart';

/// Horizontal scrollable tone selector chips
class ToneSelectorWidget extends ConsumerWidget {
  const ToneSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(textEditorProvider);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: TonePresets.all.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final tone = TonePresets.all[index];
          return _ToneChip(
            tone: tone,
            isLoading: state.isTransformingTone,
            onTap: () => _handleToneTap(context, ref, tone),
          );
        },
      ),
    );
  }

  void _handleToneTap(BuildContext context, WidgetRef ref, TonePreset tone) async {
    final state = ref.read(textEditorProvider);
    
    if (state.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Transform the tone
    await ref.read(textEditorProvider.notifier).transformTone(tone);
    
    // Show result dialog if successful
    final newState = ref.read(textEditorProvider);
    if (newState.transformedText != null && context.mounted) {
      _showTransformDialog(context, ref, tone, state.text, newState.transformedText!);
    }
  }

  void _showTransformDialog(
    BuildContext context,
    WidgetRef ref,
    TonePreset tone,
    String originalText,
    String transformedText,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tone.color.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(tone.icon, color: tone.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tone.name} Tone',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          tone.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(textEditorProvider.notifier).clearTransformedText();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Original text
                      Text(
                        'Original',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          originalText,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Transformed text
                      Text(
                        'Transformed',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: tone.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tone.color.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: tone.color.withAlpha(50)),
                        ),
                        child: Text(
                          transformedText,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(textEditorProvider.notifier).clearTransformedText();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(textEditorProvider.notifier).applyTransformedText();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Applied ${tone.name} tone'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneChip extends StatelessWidget {
  final TonePreset tone;
  final bool isLoading;
  final VoidCallback onTap;

  const _ToneChip({
    required this.tone,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: tone.color.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: tone.color.withAlpha(80)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tone.icon,
                size: 18,
                color: tone.color,
              ),
              const SizedBox(width: 6),
              Text(
                tone.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: tone.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
