import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class SignInApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignInApp> {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  AuthorizationTokenResponse _tokenResponse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Auth Demo',
        theme: _buildTheme(),
        home: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text('Sign In Demo'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Text('Hello'),
                  FlatButton(
                    child: Text('Sign In'),
                    onPressed: _onSignIn,
                  ),
                  if (_tokenResponse != null) Text(_tokenResponse.idToken)
                ]))));
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  void _onSignIn() async {
    // Secret: Dl1sXhqM7hTRa25-byi3bPtE
    final AuthorizationTokenResponse result =
        await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        '336820793242-uug0q4etb4c9tbrrtodftm5jut07397r.apps.googleusercontent.com',
        'com.googleusercontent.apps.336820793242-uug0q4etb4c9tbrrtodftm5jut07397r:/some_path',
        discoveryUrl:
            'https://accounts.google.com/.well-known/openid-configuration',
        scopes: ['openid', 'profile', 'email'],
      ),
    );
    setState(() {
      _tokenResponse = result;
    });
  }
}
