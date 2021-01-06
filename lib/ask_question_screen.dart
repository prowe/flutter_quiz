import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_client/main.dart';
import 'package:flutter_client/show_answer_screen.dart';

class AskQuestionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final text = 'What is the best color?';
  final answers = [
    'Red',
    'Green',
    'Blue',
    'Orange',
  ];
  bool _loading = true;

  @override
  void initState() {
    _getThingsOnStartup();
    super.initState();
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Question screen'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  Text(text),
                  ..._buildAnswerList(context),
                  Text('Token: ${MainApp.of(context).tokenResponse.idToken}')
                ],
              ),
            ),
    );
  }

  List<Widget> _buildAnswerList(BuildContext context) {
    return answers
        .map((answer) => RaisedButton(
              child: Text(answer),
              onPressed: () => _processAnswer(context, answer),
            ))
        .toList();
  }

  void _processAnswer(BuildContext context, String answer) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShowAnswerScreen(
            choosenAnswer: answer,
          ),
        ));
  }
}
