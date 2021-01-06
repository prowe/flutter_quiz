import 'package:flutter/material.dart';
import 'package:flutter_client/ask_question_screen.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_client/main.dart';

class SignInScreen extends StatelessWidget {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

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

  void _onSignIn(BuildContext context) async {
    var authRequest = AuthorizationTokenRequest(
      '336820793242-uug0q4etb4c9tbrrtodftm5jut07397r.apps.googleusercontent.com',
      'com.googleusercontent.apps.336820793242-uug0q4etb4c9tbrrtodftm5jut07397r:/some_path',
      discoveryUrl:
          'https://accounts.google.com/.well-known/openid-configuration',
      scopes: ['openid', 'profile', 'email'],
    );
    final AuthorizationTokenResponse result =
        await _appAuth.authorizeAndExchangeCode(authRequest);
    MainApp.of(context).tokenResponse = result;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => new AskQuestionScreen(),
      ),
    );
  }
}
