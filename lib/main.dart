import 'package:flutter/material.dart';
import 'package:quizzler/helper/quizbrain.dart';

QuizBrain quizbrain = QuizBrain();

void main() {
  runApp(QuizzlerApp());
}

class QuizzlerApp extends StatelessWidget {
  const QuizzlerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  Future<void> _showAlertDialog(
      {required BuildContext context, title, desc, result}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('You Final Score is $result'),
                  Text('$desc'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Finish'))
            ],
          );
        });
  }

  void checkAnswer(bool userSelectedAnswer) {
    bool correctAnswer = quizbrain.getQuestionAnswer();
    setState(() {
      if (quizbrain.isFinished()) {
        _showAlertDialog(
          context: context,
          title: 'Finished',
          desc: 'You have reached the end of Quiz. Refresh to reload!',
          result: quizbrain.getFinalResult(),
        );
        quizbrain.reset();
        scoreKeeper = [];
      } else {
        if (userSelectedAnswer == correctAnswer) {
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          quizbrain.updateCorrectAttempt();
        } else {
          scoreKeeper.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        quizbrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizbrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                checkAnswer(true);
              },
              child: Text(
                'TRUE',
                style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                checkAnswer(false);
              },
              child: Text(
                'FALSE',
                style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
