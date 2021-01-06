import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_client/sign_in_screen.dart';

/*
  Some Notes:

  Screens:
    Splash

    Question
    Result
    My Account
  Should there be some sort of global menu?
  How does the "stack" / back work?

  https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
  To flow creds down the tree
  https://pub.dev/documentation/graphql/latest/graphql/AuthLink-class.html is helpful

*/

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainAppState();

  static MainAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MainAppState>();
  }
}

class MainAppState extends State<MainApp> {
  TokenResponse _tokenResponse;

  set tokenResponse(TokenResponse response) => setState(() {
        this._tokenResponse = response;
      });

  TokenResponse get tokenResponse => this._tokenResponse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),
    );
  }
}
