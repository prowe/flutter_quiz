import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_client/show_answer_screen.dart';

class AskQuestionScreen extends StatelessWidget {
  final text = 'What is the best color?';
  final answers = [
    'Red',
    'Green',
    'Blue',
    'Orange',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Question screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(text),
            ..._buildAnswerList(context),
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
