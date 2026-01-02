import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/text_editor_provider.dart';
import '../widgets/language_selector_widget.dart';
import '../widgets/suggestion_card_widget.dart';
import '../widgets/text_editor_widget.dart';
import '../widgets/tone_selector_widget.dart';

/// Main home screen with text editor and AI features
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(textEditorProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Smart Keyboard'),
        actions: [
          const LanguageSelectorWidget(showLabel: false),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  // Text Editor
                  const TextEditorWidget(),
                  
                  const SizedBox(height: 16),
                  
                  // Suggestion Card (shows when there are errors)
                  const SuggestionCardWidget(),
                  
                  // Error display
                  if (state.error != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, 
                              color: AppTheme.error, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: TextStyle(
                                color: AppTheme.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              ref.read(textEditorProvider.notifier).clearError();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
          
          // Bottom action bar
          _BottomActionBar(
            text: state.text,
            onCopy: () => _handleCopy(context, state.text),
            onClear: () => ref.read(textEditorProvider.notifier).clearText(),
            onCheckGrammar: () {
              ref.read(textEditorProvider.notifier).checkGrammar();
            },
          ),
        ],
      ),
    );
  }

  void _handleCopy(BuildContext context, String text) {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to copy'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final String text;
  final VoidCallback onCopy;
  final VoidCallback onClear;
  final VoidCallback onCheckGrammar;

  const _BottomActionBar({
    required this.text,
    required this.onCopy,
    required this.onClear,
    required this.onCheckGrammar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tone selector
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: ToneSelectorWidget(),
            ),
            
            const SizedBox(height: 12),
            
            // Action buttons row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Copy button
                  _ActionButton(
                    icon: Icons.copy_outlined,
                    label: 'Copy',
                    onTap: onCopy,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Check Grammar button
                  _ActionButton(
                    icon: Icons.spellcheck,
                    label: 'Check Grammar',
                    onTap: onCheckGrammar,
                    isPrimary: true,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Clear button
                  _ActionButton(
                    icon: Icons.clear_all,
                    label: 'Clear',
                    onTap: onClear,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isPrimary 
                  ? AppTheme.primary.withAlpha(20) 
                  : Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: isPrimary 
                  ? Border.all(color: AppTheme.primary.withAlpha(50))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon, 
                  size: 18, 
                  color: isPrimary ? AppTheme.primary : AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: isPrimary ? AppTheme.primary : AppTheme.textSecondary,
                      fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
