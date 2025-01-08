import 'package:flutter/material.dart';
import 'package:quizsquare/models/question.dart';

class ReportCard extends StatefulWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;
  ReportCard({required this.questions, required this.answers});
  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  late int correctAnswers;

  @override
  Widget build(BuildContext context) {
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
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF303F9F),
            title: Text('Report'),
            elevation: 0,
          ),
          body: Container(
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
            child: Column(
              children: [
                myCard(
                  titleText:"Total Questions" ,
                  trailingText: "${widget.questions.length}",
                ),

                myCard(
                  titleText:"Score" ,
                  trailingText: "${correct/widget.questions.length * 100}%",
                ),

                myCard(
                  titleText:"Correct Answers" ,
                  trailingText: "$correct/${widget.questions.length}",
                ),

                myCard(
                  titleText:"Incorrect Answers" ,
                  trailingText: "${widget.questions.length - correct}/${widget.questions.length}",
                ),

              ],
            ),
          )),
    );
  }
}

class myCard extends StatefulWidget {

  String titleText, trailingText;
  myCard({required this.titleText, required this.trailingText});

  @override
  _myCardState createState() => _myCardState();
}

class _myCardState extends State<myCard> {

  final TextStyle titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500
  );
  final TextStyle trailingStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        color: Colors.white30,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10.0)
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text("${widget.titleText}", style: titleStyle,),
          trailing: Text("${widget.trailingText}", style: trailingStyle),
        ),
      ),
    );
  }
}
