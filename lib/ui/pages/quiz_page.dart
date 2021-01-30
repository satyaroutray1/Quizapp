import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/models/colorScheme.dart';
import 'package:opentrivia/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin{
  Animation animation;
  AnimationController animationController, animationController1;

  FToast fToast;


  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    /*
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });*/
  }

  MyColorScheme myColorScheme;
  @override
  void initState() {
    // TODO: implement initState
    myColorScheme = new MyColorScheme();
    fToast = FToast();
    fToast.init(context);
    super.initState();

    animationController = AnimationController(vsync: this,
    duration: Duration(seconds: 2));

    animation = IntTween(begin: 0, end: _currentIndex+1).animate(
      CurvedAnimation(parent: animationController,
          curve: Curves.ease)
    );

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final List item = [];

  void check(){
    print("${_answers}, ${_answers.length}, ${_answers.runtimeType}, ${(_answers.values.toList())[0]} ");
    Map map = _answers;
    map.forEach((k, v) => item.add(Options(num: k, option: v)));

  }


  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    print("now options ${options.length}");
    List<Widget> _createChildren() {
      return new List<Widget>.generate(options.length, (int index) {
        return InkWell(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5C6BC0))
              ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            //color: Color(0xff6949FD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(options[index].toString(), style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize
                  ),),
                  //Icon(Icons.check_circle),
                  Icon(Icons.radio_button_off_outlined,color: Colors.white,)
                ],
              )),
          onTap: (){
            setState(() {
              print("${options[index]}");

              _answers[_currentIndex] = options[index];

              animationController.reset();
              _currentIndex++;

              animation = IntTween(begin: _currentIndex, end: _currentIndex + 1)
                  .animate(
                  CurvedAnimation(
                      parent: animationController, curve: Curves.ease)
              );

              animationController.forward();
              check();
            });
          },
        );
      });
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text(widget.category.name),
              elevation: 0,
            ),
            body: Stack(
              children: <Widget>[
                ClipPath(
                  //clipper: RoundedDiagonalPathClipper(),
                  child: /*Container(
                    decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                    height: 200,
                  ),
                  */
                  Container(
                    //height: MediaQuery.of(context).size.height+2000,
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
                                      fontSize: 18
                                  ),),

                                  Text(animation.value.toString(), style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                  Text("/10 ", style: TextStyle(
                                      fontSize: 18
                                  ),),
                                ],
                              )
                          ),

                          CircularCountDownTimer(
                            duration: 10,
                            controller: CountDownController(),
                            width: MediaQuery.of(context).size.width / 10,
                            height: MediaQuery.of(context).size.width / 10,
                            color: Colors.grey[300],
                            fillColor: Colors.black,
                            backgroundColor: Colors.black12,
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

                              _showToast("Times Up!");

                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => //Result()
                                QuizFinishedPage(
                                    questions: widget.questions, answers: _answers)
                                ),
                              );
                              */
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
                                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                              color: myColorScheme.QuestionColor,
                            ) ,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options.map((option) {
                              return RadioListTile(
                                title: Text(HtmlUnescape().convert("$option"),
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.headline6.fontSize
                                  ) ,
                                ),
                                groupValue: _answers[_currentIndex],
                                value: option,

                                onChanged: (value) {
                                  setState(() {
                                    _answers[_currentIndex] = option;

                                    animationController.reset();
                                    _currentIndex++;

                                    animation = IntTween(begin: _currentIndex, end: _currentIndex + 1).animate(
                                        CurvedAnimation(parent: animationController, curve: Curves.ease)
                                    );

                                    animationController.forward();
                                    check();
                                    print("options ${options}");
                                  },);
                                },
                              );
                            }
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _currentIndex == (widget.questions.length - 1) ?Container(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: MediaQuery.of(context).size.width > 800
                                  ? const EdgeInsets.symmetric(vertical: 20.0,horizontal: 64.0) : null,
                            ),
                            child: Text(
                              //_currentIndex == (widget.questions.length - 1) ?
                              "Submit"
                                //  : "Next",// style: MediaQuery.of(context).size.width > 800 ? TextStyle(fontSize: 30.0) : null,
                            ),
                            onPressed: _nextSubmit,
                          ),
                        ):Container(),
                      ),
                      Column(
                        children: [
                          for(int i = 0; i<options.length;i++)
                            _createChildren().elementAt(i)

                        ],
                      )



                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      //child: ,
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      /*_key.currentState.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      )
      );*/
      _showToast("You must select an answer to continue.");
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


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => //Result()
          QuizFinishedPage(
            questions: widget.questions, answers: _answers)
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
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
  }
}


