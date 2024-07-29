import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'verification_page.dart';
import 'login_page.dart';
import 'video_editor_page.dart';
import 'chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/verify') {
          final String email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return VerificationPage(email: email);
            },
          );
        }
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => LoginPage());
        }
        if (settings.name == '/video_editor') {
          return MaterialPageRoute(builder: (context) => VideoEditorPage());
        }
        if (settings.name == '/chat') {
          final String? outputFilePath = settings.arguments as String?;
          return MaterialPageRoute(builder: (context) => ChatPage(outputFilePath: outputFilePath));
        }
        return MaterialPageRoute(builder: (context) => RegistrationPage());
      },
    );
  }
}
