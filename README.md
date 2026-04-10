# 🚀 CodeSage AI

![Flutter](https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white)
![AI Powered](https://img.shields.io/badge/AI-Powered-7C3AED)
![OpenRouter](https://img.shields.io/badge/OpenRouter-API-111827)
![Status](https://img.shields.io/badge/Project-Active-22C55E)

---

## ✨ About the Project

CodeSage AI is a smart AI-powered code reviewer built using **Flutter**.  
It helps developers analyze code, understand logic, improve quality, and optimize performance using AI.

---

## ✨ Features

- 🔍 AI Code Review (issues + suggestions)
- 💡 Code Explanation in simple language
- ⚡ Improved Code Generation
- 📊 Time & Space Complexity Analysis
- 🔁 Code Comparison (Original vs Improved)
- 📂 Upload Code File
- 📥 Download Improved Code
- 📋 Copy Code instantly
- 🌐 Auto Language Detection
- 🎨 Modern UI with syntax highlighting

---

## 🛠️ Tech Stack

- Flutter
- Dart
- OpenRouter API
- HTTP package
- flutter_dotenv
- code_text_field
- flutter_highlight
- diffutil_dart

---

## 📂 Project Structure

lib/  
├── models/  
│   └── review_result.dart  
├── pages/  
│   └── ai_code_reviewer_page.dart  
├── services/  
│   ├── mock_ai_reviewer.dart  
│   └── openrouter_ai_reviewer.dart  
├── util/  
│   ├── code_auto_detect_helper.dart  
│   ├── code_download_helper.dart  
│   ├── code_language_helper.dart  
│   └── code_upload_helper.dart  
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
└── main.dart  

---

## ⚙️ Setup Instructions

### 1. Clone the repository

git clone https://github.com/your-username/codesage-ai.git  
cd codesage-ai  

---

### 2. Install dependencies

flutter pub get  

---

### 3. Create a `.env` file

Create a `.env` file in the root folder and add:

OPENROUTER_API_KEY=your_api_key_here  
OPENROUTER_MODEL=deepseek/deepseek-r1-0528:free  

---

### 4. Run the project

flutter run  

For desktop:

flutter run -d windows  

---

## ⚠️ Important Note

When using Flutter Web, direct API calls may fail due to **CORS (browser restriction)**.  
For best experience, run on:

- Windows  
- Android  
- Or use a backend proxy  

---

## 🚧 Challenges Solved

- Integrated AI-based code review  
- Managed structured JSON parsing from AI responses  
- Implemented syntax highlighting  
- Built code comparison UI  
- Added file upload & download  
- Implemented auto language detection  

---

## 🔮 Future Improvements

- Save Review History  
- Smart Caching  
- Backend integration  
- Authentication system  
- Export reports (PDF)  
- Advanced static analysis  

---

## 👩‍💻 Author

**Akshita Dhiman**

Passionate about building impactful and user-friendly software projects.

---

## 🌟 Support

If you like this project, consider giving it a ⭐ on GitHub.

---

## 📌 Tagline

**Write better code, faster — with AI.**
