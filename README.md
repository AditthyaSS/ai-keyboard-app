<div align="center">

<!-- Flutter Animated Header -->
<img src="https://user-images.githubusercontent.com/74038190/212284115-f47cd8ff-2ffb-4b04-b5bf-4d1c14c0247f.gif" width="100%">

<br/>

# ✨ Smart Keyboard Assistant ✨

<img src="https://readme-typing-svg.herokuapp.com?font=Poppins&weight=700&size=35&pause=1000&color=02569B&center=true&vCenter=true&width=600&height=70&lines=AI-Powered+%F0%9F%A4%96;Indian+Languages+%F0%9F%87%AE%F0%9F%87%B3;Grammar+Checker+%E2%9C%A8;Tone+Transformer+%F0%9F%8E%AD" alt="Typing SVG" />

<br/>

<!-- Flutter Badges Row -->
<a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/></a>
<a href="https://ai.google.dev"><img src="https://img.shields.io/badge/Google_Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white" alt="Gemini"/></a>
<a href="#"><img src="https://img.shields.io/badge/Material_3-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material 3"/></a>

<br/><br/>

<!-- Pixel Character -->
<img src="assets/pixel/construction_icon.avif" width="120" alt="Pixel Builder"/>

<br/>

### 🚧 This repo is under construction! 🚧
*Building something awesome with AI magic* ✨



<img src="https://user-images.githubusercontent.com/74038190/212284100-561aa473-3905-4a80-b561-0d28506553ee.gif" width="700">

</div>

---

<div align="center">

## 🎨 Built with Flutter Colors

<img src="https://user-images.githubusercontent.com/74038190/235224431-e8c8c12e-6826-47f1-89fb-2ddad83b3abf.gif" width="300"/>

</div>

---

## 🌟 Features

<table>
<tr>
<td>

### ✏️ **Grammar & Spelling**
```
🔍 Real-time error detection
✨ AI-powered corrections
📝 Inline suggestions
⚡ 800ms debounce
```

</td>
<td>

### 🎭 **Tone Transformation**
```
😊 Friendly    - Warm & casual
💼 Professional - Formal & polished
🎉 Casual     - Fun & relaxed
🎩 Formal     - Respectful & proper
```

</td>
</tr>
<tr>
<td>

### 🇮🇳 **9 Languages**
```
🔹 Hindi     हिंदी
🔹 Tamil     தமிழ்
🔹 Telugu    తెలుగు
🔹 Bengali   বাংলা
🔹 Marathi   मराठी
🔹 Gujarati  ગુજરાતી
🔹 Kannada   ಕನ್ನಡ
🔹 Malayalam മലയാളം
🔹 Punjabi   ਪੰਜਾਬੀ
```

</td>
<td>

### 🔐 **Privacy First**
```
🛡️ Secure local storage
🔑 Encrypted API keys
📵 No data tracking
✅ Your data, your device
```

</td>
</tr>
</table>

---

<div align="center">

## 🏗️ Architecture

<img src="https://user-images.githubusercontent.com/74038190/229223263-cf2e4b07-2615-4f87-9c38-e37600f8381a.gif" width="400"/>

</div>

```
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   ┌─────────────────────────────────────────────────────────┐ ║
║   │               🎨 PRESENTATION LAYER                     │ ║
║   │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐│ ║
║   │  │  Splash  │  │  Setup   │  │   Home   │  │ Settings ││ ║
║   │  │  Screen  │  │  Screen  │  │  Screen  │  │  Screen  ││ ║
║   │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘│ ║
║   │       └─────────────┴──────┬──────┴─────────────┘      │ ║
║   │                            │                            │ ║
║   │  ┌─────────────────────────▼───────────────────────────┐│ ║
║   │  │          🔄 RIVERPOD PROVIDERS                      ││ ║
║   │  │   ApiKeyProvider │ TextEditorProvider │ Language   ││ ║
║   │  └─────────────────────────┬───────────────────────────┘│ ║
║   └──────────────────────────────────────────────────────────┘ ║
║                                │                               ║
║   ┌──────────────────────────────────────────────────────────┐ ║
║   │               📦 DATA LAYER                              │ ║
║   │  ┌──────────┐  ┌──────────┐  ┌──────────┐               │ ║
║   │  │  Models  │  │ Services │  │Repository│               │ ║
║   │  └──────────┘  └────┬─────┘  └──────────┘               │ ║
║   └──────────────────────────────────────────────────────────┘ ║
║                          │                                     ║
║   ┌──────────────────────▼───────────────────────────────────┐ ║
║   │               🤖 GEMINI AI                               │ ║
║   │         Grammar • Tone • Translation                     │ ║
║   └──────────────────────────────────────────────────────────┘ ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

<div align="center">

## 📁 Project Structure

</div>

```dart
/// 🎮 Smart Keyboard App Structure
///
/// lib/
/// ├── 📱 main.dart              // App entry point
/// ├── 🎯 app.dart               // MaterialApp & Routes
/// │
/// ├── 🎨 core/
/// │   ├── constants/
/// │   │   ├── app_constants.dart    // API URLs, timing
/// │   │   ├── tone_presets.dart     // 4 tone types
/// │   │   └── indian_languages.dart // 9 languages
/// │   ├── theme/
/// │   │   └── app_theme.dart        // Material 3 theme
/// │   └── utils/
/// │       └── validators.dart       // Input validation
/// │
/// ├── 📦 data/
/// │   ├── models/
/// │   │   ├── text_suggestion.dart  // Grammar results
/// │   │   └── translation_result.dart
/// │   ├── services/
/// │   │   ├── gemini_service.dart   // AI integration
/// │   │   ├── storage_service.dart  // Secure storage
/// │   │   └── translation_service.dart
/// │   └── repositories/
/// │       └── ai_repository.dart    // Data aggregation
/// │
/// └── 🖼️ presentation/
///     ├── providers/
///     │   ├── api_key_provider.dart
///     │   ├── text_editor_provider.dart
///     │   └── language_provider.dart
///     ├── screens/
///     │   ├── splash_screen.dart
///     │   ├── setup_screen.dart
///     │   ├── home_screen.dart
///     │   └── settings_screen.dart
///     └── widgets/
///         ├── text_editor_widget.dart
///         ├── tone_selector_widget.dart
///         ├── language_selector_widget.dart
///         └── suggestion_card_widget.dart
```

---

<div align="center">

## 🚀 Quick Start

<img src="https://user-images.githubusercontent.com/74038190/216649426-0c2ee152-84d8-4707-85c4-27a378d2f78a.gif" width="200"/>

</div>

### Prerequisites

| Requirement | Version | Status |
|:-----------:|:-------:|:------:|
| Flutter SDK | ^3.10.4 | ✅ |
| Dart SDK | Latest | ✅ |
| Gemini API Key | Free | 🔑 |

### Installation

```bash
# Clone the magic ✨
git clone https://github.com/AditthyaSS/ai-keyboard-app.git

# Enter the realm 🚪
cd ai-keyboard-app

# Summon dependencies 📦
flutter pub get

# Launch! 🚀
flutter run
```

<div align="center">

### 🔑 Get Your Free API Key

<a href="https://makersuite.google.com/app/apikey">
  <img src="https://img.shields.io/badge/Get_Gemini_Key-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Get API Key" width="250"/>
</a>

</div>

---

<div align="center">

## 📊 Tech Specs

<img src="https://user-images.githubusercontent.com/74038190/212284158-e840e285-664b-44d7-b79b-e264b5e54825.gif" width="400"/>

</div>

| Category | Technology |
|:--------:|:----------:|
| 🎯 Framework | Flutter 3.10+ |
| 📝 Language | Dart |
| 🔄 State | Riverpod |
| 🤖 AI | Google Gemini |
| 🎨 Design | Material 3 |
| 🔐 Storage | flutter_secure_storage |
| ✨ Animations | flutter_animate |

---

<div align="center">

## 🤝 Contributing

<img src="https://user-images.githubusercontent.com/74038190/213866269-5f8e9c9f-d0e7-4f5a-8b4e-0f3e4c2d9a5a.gif" width="200"/>

**We'd love your help!**

<a href="https://github.com/AditthyaSS/ai-keyboard-app/fork">
  <img src="https://img.shields.io/badge/Fork_this_repo-02569B?style=for-the-badge&logo=github&logoColor=white"/>
</a>

</div>

```
1. 🍴 Fork it
2. 🌿 Create your branch (git checkout -b feature/amazing)
3. 💾 Commit changes (git commit -m 'Add amazing feature')
4. 📤 Push it (git push origin feature/amazing)
5. 🎯 Open a Pull Request
```

---

<div align="center">

## 📜 License

<img src="https://img.shields.io/badge/MIT-License-02569B?style=for-the-badge"/>

This project is licensed under the MIT License

---

<br/>

<img src="https://capsule-render.vercel.app/api?type=waving&color=02569B&height=100&section=footer"/>

**Made with 💙 and Flutter**
<br/>

<!-- Pixel Flutter -->
<img src="assets/pixel/flutter_icon.png" width="80" alt="Flutter"/>

<br/>
<img src="https://user-images.githubusercontent.com/74038190/212284115-f47cd8ff-2ffb-4b04-b5bf-4d1c14c0247f.gif" width="100%">

</div>
