import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../providers/api_key_provider.dart';
import '../providers/language_provider.dart';

/// Splash screen shown on app launch
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Load saved language
    await ref.read(languageProvider.notifier).loadSavedLanguage();

    // Check API key
    await ref.read(apiKeyProvider.notifier).checkApiKey();

    if (!mounted) return;

    final hasValidKey = ref.read(apiKeyProvider).hasValidKey;

    // Navigate to appropriate screen
    if (hasValidKey) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.withBlue(255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withAlpha(80),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.keyboard_alt_rounded,
                size: 50,
                color: Colors.white,
              ),
            ).animate().scale(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'Smart Keyboard',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 500),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'AI-powered typing assistant',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 500),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primary.withAlpha(180),
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 800),
            ),
          ],
        ),
      ),
    );
  }
}
