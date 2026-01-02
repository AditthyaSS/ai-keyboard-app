import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/indian_languages.dart';
import '../providers/language_provider.dart';

/// Dropdown widget for language selection
class LanguageSelectorWidget extends ConsumerWidget {
  final bool showLabel;

  const LanguageSelectorWidget({
    super.key,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(languageProvider);
    final languages = ref.watch(availableLanguagesProvider);

    return PopupMenuButton<IndianLanguage>(
      initialValue: selectedLanguage,
      onSelected: (language) {
        ref.read(languageProvider.notifier).setLanguage(language);
      },
      itemBuilder: (context) => languages.map((language) {
        final isSelected = language.code == selectedLanguage.code;
        return PopupMenuItem<IndianLanguage>(
          value: language,
          child: Row(
            children: [
              Text(
                language.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      language.nativeName,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary 
                            : null,
                      ),
                    ),
                    Text(
                      language.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLanguage.emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            if (showLabel)
              Text(
                selectedLanguage.nativeName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}
