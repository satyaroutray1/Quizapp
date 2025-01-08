import 'package:flutter/material.dart';
import 'package:quizsquare/models/question.dart';
import 'package:quizsquare/view/widgets/button.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'check_answers.dart';
import 'home.dart';
import 'report_card.dart';

class QuizFinishedPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  

  QuizFinishedPage({required this.questions, required this.answers});

  @override
  _QuizFinishedPageState createState() => _QuizFinishedPageState();
}

class _QuizFinishedPageState extends State<QuizFinishedPage> {

  late int correctAnswers;
  bool __visible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (this.mounted) {
        setState(() {
          __visible=false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    int correct = 0;
    this.widget.answers.forEach((index,value){
      if(this.widget.questions[index].correctAnswer == value)
        correct++;
    });
    final TextStyle titleStyle = TextStyle(
      color: Colors.black87,
      fontSize: 16.0,
      fontWeight: FontWeight.w500
    );
    final TextStyle trailingStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.bold
    );


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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303F9F),
        title: Text('Result'),
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
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
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white12,
                        //height: MediaQuery.of(context).size.height/2,
                        child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(minimum: 0, maximum: 100,
                                  ranges: <GaugeRange>[
                                    GaugeRange(startValue: 0, endValue: 35, color:Colors.red),
                                    GaugeRange(startValue: 35,endValue: 70,color: Colors.orange),
                                    GaugeRange(startValue: 70,endValue: 100,color: Colors.green)],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      enableAnimation: true,
                                        animationDuration: 5000,
                                        animationType: AnimationType.bounceOut,
                                        value: correct/widget.questions.length * 100)],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Container(
                                            child: Text('${(correct/widget.questions.length * 100)} %',
                                                style: TextStyle(fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                        angle: 90,
                                        positionFactor: 0.5
                                    )]
                              )])
                      ),
                    ),

                    //SizedBox(height: 20.0),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          myButton(buttonName: "Check Solutions", function: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => CheckAnswersPage(questions: widget.questions, answers: widget.answers,)
                            ));
                          },),

                          Row(
                            children: [
                              Expanded(
                                flex:1,
                                child: myButton(buttonName: "Report", function: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ReportCard(questions: widget.questions, answers: widget.answers,)
                                  ));
                                },),
                              ),
                              Expanded(
                                flex: 1,
                                child: myButton(buttonName: "Home", function: (){
                                  Navigator.pushReplacement( context,
                                    MaterialPageRoute(builder: (context) => HomePage()),
                                  );
                                },),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
