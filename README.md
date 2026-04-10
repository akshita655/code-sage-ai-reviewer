# 🚀 CodeSage AI

![Flutter](https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white)
![AI Powered](https://img.shields.io/badge/AI-Powered-7C3AED)
![OpenRouter](https://img.shields.io/badge/OpenRouter-API-111827)
![Status](https://img.shields.io/badge/Project-Active-22C55E)
![Platform](https://img.shields.io/badge/Platform-Flutter%20Web%20%7C%20Desktop-0EA5E9)

CodeSage AI is a smart AI-powered code reviewer built with **Flutter**. It analyzes code, explains logic, suggests improvements, generates improved code, compares old vs improved versions, and provides complexity analysis in a clean developer-focused UI.

---

## ✨ Features

- 🔍 **AI Code Review**
  - Detects issues in code
  - Provides practical suggestions
  - Generates a code quality score

- 💡 **Code Explanation**
  - Explains code in simple language
  - Helps beginners understand logic quickly

- ⚡ **Improved Code Generation**
  - Returns a cleaner version of code
  - Keeps the original programming language

- 📊 **Complexity Analysis**
  - Time Complexity
  - Space Complexity
  - Explanation of complexity

- 🔁 **Code Comparison**
  - Compare original code with improved code
  - Popup-based side-by-side comparison view

- 📂 **File Upload**
  - Upload code files directly from your device

- 🌐 **Auto Language Detection**
  - Detects programming language automatically
  - Manual language dropdown still available

- 📥 **Download & Copy**
  - Download improved code
  - Copy improved code instantly

- 🎨 **Modern UI**
  - Dark theme
  - Syntax highlighting
  - Hover effects
  - Smooth layout for developers

---

## 🛠️ Tech Stack

- **Frontend:** Flutter
- **Language:** Dart
- **AI API:** OpenRouter
- **Syntax Highlighting:** `code_text_field`, `flutter_highlight`
- **Networking:** `http`
- **Environment Variables:** `flutter_dotenv`

---

## 📸 Core Modules

- Code Editor with syntax highlighting
- AI Review Engine
- Code Explanation Engine
- Improved Code Panel
- Compare Dialog
- Complexity Analysis Card
- File Upload / Download Helpers
- Auto Language Detection

---

## 📂 Project Structure

```bash
lib/
│
├── models/
│   └── review_result.dart
│
├── pages/
│   └── ai_code_reviewer_page.dart
│
├── services/
│   ├── mock_ai_reviewer.dart
│   └── openrouter_ai_reviewer.dart
│
├── util/
│   ├── code_auto_detect_helper.dart
│   ├── code_download_helper.dart
│   ├── code_language_helper.dart
│   └── code_upload_helper.dart
│
├── widgets/
│   ├── app_header.dart
│   ├── code_compare_dialog.dart
│   ├── code_editor_card.dart
│   ├── complexity_card.dart
│   ├── explain_button.dart
│   ├── explanation_card.dart
│   ├── hover_text_action_button.dart
│   ├── improved_code_card.dart
│   ├── language_dropdown.dart
│   ├── result_list_card.dart
│   ├── review_button.dart
│   └── score_card.dart
│
└── main.dart
