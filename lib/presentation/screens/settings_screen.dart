import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../providers/api_key_provider.dart';
import '../providers/language_provider.dart';

/// Settings screen for updating API key and app configuration
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _geminiController = TextEditingController();
  bool _showGeminiKey = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentKey();
  }

  Future<void> _loadCurrentKey() async {
    final state = ref.read(apiKeyProvider);
    if (state.geminiKey != null) {
      _geminiController.text = state.geminiKey!;
    }
  }

  @override
  void dispose() {
    _geminiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(apiKeyProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Language Section
            _buildSectionHeader('Language'),
            Card(
              child: ListTile(
                leading: Text(
                  language.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(language.nativeName),
                subtitle: Text(language.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageSelector(context),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // API Key Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('API Key'),
                if (!_isEditing)
                  TextButton(
                    onPressed: () => setState(() => _isEditing = true),
                    child: const Text('Edit'),
                  ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Gemini Key
                    _buildKeyField(
                      label: 'Gemini API Key',
                      controller: _geminiController,
                      showKey: _showGeminiKey,
                      onToggle: () {
                        setState(() => _showGeminiKey = !_showGeminiKey);
                      },
                      enabled: _isEditing,
                    ),
                    
                    if (_isEditing) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _loadCurrentKey();
                                setState(() => _isEditing = false);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _saveKey,
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionHeader('About'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Version'),
                    trailing: Text(
                      AppConstants.appVersion,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.code),
                    title: Text('Smart Keyboard Assistant'),
                    subtitle: Text('AI-powered typing for Indian languages'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Danger Zone
            _buildSectionHeader('Data'),
            Card(
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: AppTheme.error),
                title: Text(
                  'Clear All Data',
                  style: TextStyle(color: AppTheme.error),
                ),
                subtitle: const Text('Remove API key and settings'),
                onTap: () => _showClearDataDialog(context),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildKeyField({
    required String label,
    required TextEditingController controller,
    required bool showKey,
    required VoidCallback onToggle,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: !showKey,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: enabled ? 'Enter API key' : '••••••••••••••••••••',
            suffixIcon: IconButton(
              icon: Icon(showKey ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
            filled: !enabled,
            fillColor: enabled ? null : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final languages = ref.read(availableLanguagesProvider);
        final currentLang = ref.read(languageProvider);
        
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = lang.code == currentLang.code;
                    
                    return ListTile(
                      leading: Text(lang.emoji, style: const TextStyle(fontSize: 24)),
                      title: Text(lang.nativeName),
                      subtitle: Text(lang.name),
                      trailing: isSelected 
                          ? Icon(Icons.check, color: AppTheme.primary) 
                          : null,
                      selected: isSelected,
                      onTap: () {
                        ref.read(languageProvider.notifier).setLanguage(lang);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveKey() async {
    final success = await ref.read(apiKeyProvider.notifier).saveApiKey(
      _geminiController.text.trim(),
    );

    if (success && mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will remove your API key and settings. You will need to set them up again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(apiKeyProvider.notifier).clearApiKey();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/setup',
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
