
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizsquare/models/question.dart';
import 'package:quizsquare/view/widgets/button.dart';

import 'home.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int,dynamic> answers;

  const CheckAnswersPage({required this.questions, required this.answers});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303F9F),
        title: Text('Check Answers'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            //clipper: WaveClipperTwo(),
            child: Container(
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
              height: double.infinity,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length+1,
            itemBuilder: _buildItem,

          )
        ],
      ),
    );
  }
  Widget _buildItem(BuildContext context, int index) {
    if(index == questions.length) {
      return myButton(
        buttonName: 'Done',
        function: (){
          Navigator.pushReplacement( context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );        },

      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      color: Colors.white12,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(HtmlUnescape().convert(question.question), style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),),
            SizedBox(height: 5.0),
            Row(
              children: [
                correct ? Icon(Icons.check_circle, color: Colors.green,): Icon(Icons.cancel_outlined, color: Colors.red,),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(HtmlUnescape().convert("${answers[index]}"), style: TextStyle(
                      color: correct ? Colors.green : Colors.red,
                      decoration: correct? null: TextDecoration.lineThrough,
                      fontSize: 18.0,
                      fontWeight: correct? FontWeight.bold : null
                  ),),
                ),

              ],
            ),

            SizedBox(height: 5.0),
            correct ? Container(): Text.rich(TextSpan(
              children: [
                TextSpan(text: "Answer: "),
                TextSpan(text: HtmlUnescape().convert(question.correctAnswer) , style: TextStyle(
                  fontWeight: FontWeight.w500,
                ))
              ]
            ),style: TextStyle(
              fontSize: 16.0,
              color: Colors.white
            ),)
          ],
        ),
      ),
    );
  }
}