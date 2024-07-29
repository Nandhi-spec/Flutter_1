import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  VerificationPage({required this.email});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _codeController = TextEditingController();

  void _verifyCode() {
    String enteredCode = _codeController.text;
    String actualCode = "123456";
    if (enteredCode == actualCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified successfully!')),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid verification code. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'A verification code has been sent to ${widget.email}.',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Enter verification code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
