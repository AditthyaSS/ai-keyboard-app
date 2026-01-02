import 'package:flutter/material.dart';

/// Tone preset for text transformation
class TonePreset {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String promptDescription;

  const TonePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.promptDescription,
  });
}

/// Available tone presets for text transformation
class TonePresets {
  TonePresets._();

  static const List<TonePreset> all = [
    TonePreset(
      id: 'friendly',
      name: 'Friendly',
      description: 'Warm and conversational',
      icon: Icons.emoji_emotions_outlined,
      color: Color(0xFFF97316), // Orange
      promptDescription: 'warm, friendly, and conversational tone. Use casual language that feels approachable and personable.',
    ),
    TonePreset(
      id: 'professional',
      name: 'Professional',
      description: 'Business-appropriate',
      icon: Icons.business_center_outlined,
      color: Color(0xFF2563EB), // Blue
      promptDescription: 'professional and business-appropriate tone. Use clear, concise language suitable for workplace communication.',
    ),
    TonePreset(
      id: 'casual',
      name: 'Casual',
      description: 'Relaxed and informal',
      icon: Icons.weekend_outlined,
      color: Color(0xFF10B981), // Green
      promptDescription: 'very casual and relaxed tone. Use informal language, contractions, and a laid-back style.',
    ),
    TonePreset(
      id: 'formal',
      name: 'Formal',
      description: 'Sophisticated and polished',
      icon: Icons.school_outlined,
      color: Color(0xFF8B5CF6), // Purple
      promptDescription: 'formal and sophisticated tone. Use polished, refined language appropriate for official or academic contexts.',
    ),
  ];

  static TonePreset getById(String id) {
    return all.firstWhere(
      (preset) => preset.id == id,
      orElse: () => all.first,
    );
  }
}
