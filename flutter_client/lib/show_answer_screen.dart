import 'package:flutter/material.dart';
import 'package:flutter_client/ask_question_screen.dart';

class ShowAnswerScreen extends StatelessWidget {
  ShowAnswerScreen({this.choosenAnswer});

  final text = 'What is the best color?';
  final answers = [
    'Red',
    'Green',
    'Blue',
    'Orange',
  ];
  final String choosenAnswer;

  @override
  Widget build(BuildContext context) {
    final goNextQuestion = () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AskQuestionScreen()),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Answer screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(text),
            ..._buildAnswerList(),
            RaisedButton(
              child: Text('Next'),
              onPressed: goNextQuestion,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerList() {
    return answers
        .map((answer) => ListTile(
              trailing: _buildIconForAnswer(answer),
              title: Text(answer),
            ))
        .toList();
  }

  Icon _buildIconForAnswer(String answer) {
    if (answer == 'Green') {
      if (choosenAnswer == answer) {
        return Icon(
          Icons.check_circle_outline,
        );
      } else {
        return Icon(
          Icons.check,
        );
      }
    }

    if (choosenAnswer == answer) {
      return Icon(
        Icons.clear_sharp,
      );
    }
    return null;
  }
}
