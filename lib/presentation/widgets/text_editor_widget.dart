import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/text_editor_provider.dart';
import '../providers/language_provider.dart';

/// Multiline text editor widget
class TextEditorWidget extends ConsumerStatefulWidget {
  final TextEditingController? controller;

  const TextEditorWidget({
    super.key,
    this.controller,
  });

  @override
  ConsumerState<TextEditorWidget> createState() => _TextEditorWidgetState();
}

class _TextEditorWidgetState extends ConsumerState<TextEditorWidget> {
  late TextEditingController _controller;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
    
    // Sync with provider state
    final state = ref.read(textEditorProvider);
    if (state.text.isNotEmpty && _controller.text != state.text) {
      _controller.text = state.text;
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(textEditorProvider);
    final language = ref.watch(languageProvider);

    // Sync controller when text changes externally (e.g., applying corrections)
    if (_controller.text != state.text) {
      final selection = _controller.selection;
      _controller.text = state.text;
      // Try to restore cursor position
      if (selection.isValid && selection.end <= state.text.length) {
        _controller.selection = selection;
      }
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.isCheckingGrammar 
              ? Theme.of(context).colorScheme.primary.withAlpha(128)
              : Colors.grey.shade200,
          width: state.isCheckingGrammar ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.5,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: _getHintText(language.code),
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
            onChanged: (text) {
              ref.read(textEditorProvider.notifier).updateText(text);
            },
          ),
          // Loading indicator overlay
          if (state.isCheckingGrammar)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Checking...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Character count
          Positioned(
            bottom: 8,
            right: 12,
            child: Text(
              '${state.text.length}/5000',
              style: TextStyle(
                fontSize: 12,
                color: state.text.length > 5000 
                    ? Theme.of(context).colorScheme.error
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'यहाँ लिखें या बोलें...';
      case 'ta':
        return 'இங்கே எழுதவும் அல்லது பேசவும்...';
      case 'te':
        return 'ఇక్కడ రాయండి లేదా మాట్లాడండి...';
      case 'bn':
        return 'এখানে লিখুন বা বলুন...';
      case 'mr':
        return 'येथे लिहा किंवा बोला...';
      case 'gu':
        return 'અહીં લખો અથવા બોલો...';
      case 'kn':
        return 'ಇಲ್ಲಿ ಬರೆಯಿರಿ ಅಥವಾ ಮಾತನಾಡಿ...';
      case 'ml':
        return 'ഇവിടെ എഴുതുക അല്ലെങ്കിൽ സംസാരിക്കുക...';
      case 'pa':
        return 'ਇੱਥੇ ਲਿਖੋ ਜਾਂ ਬੋਲੋ...';
      default:
        return 'Start typing or speak...';
    }
  }
}
