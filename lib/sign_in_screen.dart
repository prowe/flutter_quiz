import 'package:flutter/material.dart';
import 'package:flutter_client/ask_question_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome'),
        ElevatedButton(
          child: Text('Sign In'),
          onPressed: () => _onSignIn(context),
        ),
      ],
    );
  }

  void _onSignIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => new AskQuestionScreen(),
      ),
    );
  }
}
