import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // 👈 Add this
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wellbeingu3/quiz_upload.dart';
import 'package:wellbeingu3/screens/auth/login_screen.dart';
// your main app widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WebViewPlatform.instance =
      AndroidWebViewPlatform(); // 👈 This line is required

  runApp(const WellBeingUApp());
}

class WellBeingUApp extends StatelessWidget {
  const WellBeingUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellBeingU',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(),
    );
  }
}
