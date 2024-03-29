import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // После 2 секунд переходим к экрану с вопросами
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  bool _isAnsweredCorrectly = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'questionText': 'What is the capital of France?',
      'answers': [
        {'text': 'Paris', 'score': 1},
        {'text': 'Rome', 'score': 0},
        {'text': 'Berlin', 'score': 0},
      ],
    },
    {
      'questionText': 'What is the longest river in the world?',
      'answers': [
        {'text': 'Nile', 'score': 0},
        {'text': 'Amazon', 'score': 1},
        {'text': 'Yangtze', 'score': 0},
      ],
    },
    {
      'questionText': 'Which country is known as the Land of the Rising Sun?',
      'answers': [
        {'text': 'China', 'score': 0},
        {'text': 'Japan', 'score': 1},
        {'text': 'India', 'score': 0},
      ],
    },
    {
      'questionText': 'What is the largest desert in the world?',
      'answers': [
        {'text': 'Sahara', 'score': 1},
        {'text': 'Gobi', 'score': 0},
        {'text': 'Arabian', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score, int index) {
    setState(() {
      _isAnsweredCorrectly = (score == 1); // Проверяем, правильный ли ответ
      _score += score;
      _questionIndex++;
    });

    if (_questionIndex < _questions.length) {
      // Переход к следующему вопросу
    } else {
      // Отображение финального счета
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalScreen(score: _score),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geography Quiz'),
      ),
      body: QuizBackground(
        child: _questionIndex < _questions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _questions[_questionIndex]['questionText'],
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ...(_questions[_questionIndex]['answers']
                          as List<Map<String, dynamic>>)
                      .map((answer) {
                    return AnswerWidget(
                      answerText: answer['text'],
                      onPressed: () =>
                          _answerQuestion(answer['score'], _questionIndex),
                      isCorrect: _isAnsweredCorrectly && (answer['score'] == 1),
                      isIncorrect:
                          _isAnsweredCorrectly && (answer['score'] == 0),
                    );
                  }).toList(),
                ],
              )
            : Center(
                child: FinalScreen(score: _score),
              ),
      ),
    );
  }
}

class AnswerWidget extends StatefulWidget {
  final String answerText;
  final Function onPressed;
  final bool isCorrect;
  final bool isIncorrect;

  AnswerWidget({
    required this.answerText,
    required this.onPressed,
    required this.isCorrect,
    required this.isIncorrect,
  });

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = true;
        });
        widget.onPressed();
      },
      child: Card(
        color: _isSelected
            ? widget.isCorrect
                ? Colors.green
                : Colors.red
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.answerText,
            style: TextStyle(
              color: _isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FinalScreen extends StatelessWidget {
  final int score;

  FinalScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Score'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.white],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: Text('Your final score is: $score'),
        ),
      ),
    );
  }
}

class QuizBackground extends StatelessWidget {
  final Widget child;

  QuizBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.purple, // Цвет правой части (фиолетовый)
            Colors.white, // Цвет левой части (перламутровый)
          ],
        ),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.9, // Ширина контента
        child: child,
      ),
    );
  }
}
