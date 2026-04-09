import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/ai_code_reviewer_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const AiCodeReviewerApp());
}

class AiCodeReviewerApp extends StatelessWidget {
  const AiCodeReviewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeSage AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF05060A),
        useMaterial3: true,
      ),
      home: const AiCodeReviewerPage(),
    );
  }
}