import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/view/pages/quiz_page.dart';
import 'package:opentrivia/view/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:opentrivia/models/question.dart';
import 'package:opentrivia/resources/api_provider.dart';
import 'package:progress_hud/progress_hud.dart';

import 'error.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  
  double _scale;
  AnimationController _controller;
  ProgressHUD _progressHUD;
  
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 0.1,)..addListener(() { setState(() {});});

    _controller.repeat();

    _progressHUD = new ProgressHUD(
      //backgroundColor: Colors.transparent,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading....',
    );

    super.initState();
  }
  
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF303F9F),
          title: Text('Quiz App'),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
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
              ),
            ),

            GridView.builder(
              scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    //childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 0),
                itemCount: 23,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    child:_categoryItemWidget(context, index,),
                  );
                }),

          ],
        ));
  }

  Widget _categoryItemWidget(BuildContext context, int index) {

    Category category = categories[index];
    _scale = 1 - _controller.value;

    return Transform.scale(
      scale: _scale,
      child: RaisedButton(
        elevation: 10.0,
        //highlightElevation: 1.0,
        onPressed: () {
          //_categoryPressed(context, category);

          _controller.stop();
          _startQuiz(category);
          showDialog(context: context, builder: (context){

            return Dialog(
                child: Container(
                  color: Colors.transparent,
                  child: Text("Loading...")//_progressHUD//Icon(Icons.category),
                ),
            );
          });
        },
        shape: CircleBorder(
            side: BorderSide(
                color: Colors.white,
            width: 0.5,
            style: BorderStyle.solid)
          //borderRadius: BorderRadius.circular(10.0),
        ),
        color: category.color//Colors.transparent
        ,//Colors.grey.shade800,
        textColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (category.icon != null) Icon(category.icon),
            //if (category.icon != null) SizedBox(height: 5.0),
            AutoSizeText(
              category.name,
              //minFontSize: 10.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                //fontSize: Theme.of(context).textTheme.headline6.fontSize
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              wrapWords: false,
            ),
          ],
        ),
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) {
          return QuizOptionsDialog(
            category: category,
          );
        },
        onClosing: () {},
      ),
    );
  }


  void _startQuiz(Category category) async {

    try {
      List<Question> questions =  await getQuestions(category, 10, "easy");
      Navigator.pop(context);
      if(questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) {
              return ErrorPage(
                message: "There are not enough questions in the category, with the options you selected.",);
            }
        ));
        return;
      }
      Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizPage(questions: questions, category: category,)
      ));
    }on SocketException catch (_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) {
            return ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",);
          }
      ));
    } catch(e){
      print(e.message);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) {
            return ErrorPage(message: "Unexpected error trying to connect to the API",);
          }
      ));
    }
  }
}

