import 'package:flutter/material.dart';
import 'quiz.dart';
import 'dart:core';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
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
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBank quizBank;
  List<Icon> scoreKeeper = [];
  Iterator<Quiz> iter;
  String currentQuiz;

  void loadAssets() async {
    quizBank = await QuizBank.fromFile('data/quiz.json');
    iter = quizBank.iterator;
    setNextQuiz();
  }

  void addScore(bool rightAnswer) {
    setState(() {
      if (rightAnswer) {
        scoreKeeper.add(Icon(Icons.check, color: Colors.green));
      } else {
        scoreKeeper.add(Icon(Icons.close, color: Colors.red));
      }
    });
  }

  void setNextQuiz() {
    if (iter.moveNext()) {
      setState(() {
        currentQuiz = iter.current.quiz;
      });
    } else {
      int totalScore = scoreKeeper.length;
      int score = scoreKeeper.where((icon) => icon.color == Colors.green).length;
      currentQuiz = 'Quiz ends\r\nYour score is $score/$totalScore';
    }
  }

  _QuizPageState() {
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                currentQuiz,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                addScore(iter.current.answer == true);
                setNextQuiz();
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                addScore(iter.current.answer == false);
                setNextQuiz();
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}
