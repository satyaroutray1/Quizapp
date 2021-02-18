import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quizsquare/models/category.dart';
import 'package:quizsquare/models/question.dart';
import 'package:quizsquare/resources/api_provider.dart';

import 'error.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 0.1,)..addListener(() { setState(() {});});

    _controller.repeat();

    super.initState();
  }
  

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
          elevation: 5,
          automaticallyImplyLeading: false,
        ),

        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text('Tap back again to leave'),
          ),
          child: Stack(
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
                      childAspectRatio: 1.5,
                      crossAxisSpacing:0,
                      mainAxisSpacing: 0),
                  itemCount: 20,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      child:_categoryItemWidget(context, index,),
                    );
                  }),

            ],
          ),
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
              backgroundColor: Colors.transparent,
              child: Container(
                  child: LoadingBouncingGrid.square (
                    backgroundColor: Color(0xff36E9BA),
                  )
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


  void _startQuiz(Category category) async {

    try {
      List<Question> questions =  await getQuestions(category, 10, "easy");
      Navigator.pop(context);
      if(questions.length < 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) {
              return ErrorPage(
                message: "There are not enough questions in the category, with the options you selected.",);
            }
        ));
        return;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => QuizPage(questions: questions, category: category,)
      ));
    }on SocketException catch (_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) {
            return ErrorPage(message: "Please check your internet connection.",);
          }
      ));
    } catch(e){
      print(e.message);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) {
            return ErrorPage(message: "Server is busy, Please try after sometime",);
          }
      ));
    }
  }
}

