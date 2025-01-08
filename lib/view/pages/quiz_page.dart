import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizsquare/models/category.dart';
import 'package:quizsquare/models/colorScheme.dart';
import 'package:quizsquare/models/question.dart';
import 'package:quizsquare/view/widgets/button.dart';
import 'package:quizsquare/view/widgets/toastWidget.dart';

import 'quiz_finished.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({required this.questions, required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin{

  late Animation animation;
  late AnimationController animationController;

  late MyColorScheme myColorScheme;

  @override
  void initState() {
    // TODO: implement initState
    myColorScheme = new MyColorScheme();
    fToast.init(context);

    animationController = AnimationController(vsync: this,
        duration: Duration(seconds: 1));

    animation = IntTween(begin: 0, end: _currentIndex+1).animate(
        CurvedAnimation(parent: animationController,
            curve: Curves.ease)
    );

    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final List item = [];

  void check(){
    Map map = _answers;
    map.forEach((k, v) => item.add(Options(num: k, option: v)));
    print("c ${_answers}, ${_answers.length}, ${_answers.runtimeType} ");

  }

  Color color1 = Color(0xff5C6BC0);
  Color color2 = Colors.red;
  CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {

    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    List<Widget> _createChildren() {
      return new List<Widget>.generate(options.length, (int index) {
        return InkWell(
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: color1),
                color: Colors.transparent,),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(HtmlUnescape().convert(options[index].toString()),
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                    ), overflow: TextOverflow.ellipsis,),
                  ),
                  Icon(Icons.radio_button_off_outlined,color: Colors.white,)
                ],
              )),
          onTap: (){
            setState(() {
              print("ans : ${options[index]}, ${question.correctAnswer}");
              print("_currentIndex: $_currentIndex");

              if (_currentIndex < 9) {
                print("a ${animation.value.toString()} $_currentIndex ${options[index]}");

                animationController.reset();

                animation =
                    IntTween(begin: _currentIndex+1, end: _currentIndex + 2)
                        .animate(
                        CurvedAnimation(
                            parent: animationController, curve: Curves.ease)
                    );

                animationController.forward();
                _answers[ _currentIndex] = options[index];
                check();
                _currentIndex++;

              } else {

                _answers[ _currentIndex] = options[index];
                check();
                Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => QuizFinishedPage(
                      questions: widget.questions, answers: _answers)
                  ),
                );
              }

            });
          },
        );
      });
    }

    Future<bool> onWillPop() async {
      final result = await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                  "Are you sure you want to quit the quiz?"),
              title: Text("Warning!"),
              actions: <Widget>[

                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),

                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),

              ],
            );
          });
      return result ?? false;
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            key: _key,
            appBar: AppBar(
              backgroundColor: Color(0xFF303F9F),
              title: Text(widget.category.name, style: TextStyle(
                color: Colors.white54,
              ),),
              elevation: 5,
            ),
            body: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            const Color(0xFF303F9F),
                            const Color(0xFF1F1147),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.repeated),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Question " , style: TextStyle(
                                      fontSize: 18,
                                    color: Colors.white
                                  ),),

                                  Text(animation.value.toString(), style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff36E9BA)
                                  ),),
                                  Text("/10 ", style: TextStyle(
                                      fontSize: 18, color: Colors.white
                                  ),),
                                ],
                              )
                          ),

                          CircularCountDownTimer(
                            duration: 10,
                            controller: _controller,
                            width: MediaQuery.of(context).size.width / 10,
                            height: MediaQuery.of(context).size.width / 10,
                            ringColor: Color(0xffC5CAE9),
                            backgroundColor: Color(0xFF303F9F),
                            fillColor: Color(0xff37E9BB),
                            strokeWidth: 5.0,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                                fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.SS,
                            isReverse: true,
                            isReverseAnimation: true,
                            isTimerTextShown: true,
                            autoStart: true,
                            onStart: () {
                              print('Countdown Started');
                              },
                            onComplete: () {
                              print('Countdown Ended');

                              showToast("Times Up!");

                              Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => QuizFinishedPage(
                                    questions: widget.questions, answers: _answers)
                                ),
                              );

                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Expanded(
                          child: Text(
                            HtmlUnescape().convert(
                                widget.questions[_currentIndex].question),
                            softWrap: true,
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                              color: myColorScheme.QuestionColor,
                              fontWeight: FontWeight.bold
                            ) ,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Column(
                        children: [
                          for(int i = 0; i<options.length;i++)
                            _createChildren().elementAt(i)

                        ],
                      ),
                      Expanded(
                        child: _currentIndex == (widget.questions.length - 1) ?Container(
                          alignment: Alignment.bottomCenter,
                          child: myButton(buttonName: 'Submit',
                          function: _nextSubmit,)
                        ):Container(),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      showToast("You must select an answer to continue.");
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        animationController.reset();
        _currentIndex++;

        animation = IntTween(begin: _currentIndex, end: _currentIndex + 1).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)
        );

        animationController.forward();
      });
    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => //Result()
          QuizFinishedPage(
            questions: widget.questions, answers: _answers)
        ),
      );
    }
  }

}


