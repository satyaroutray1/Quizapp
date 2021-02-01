import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/ui/pages/quiz_page.dart';
import 'package:opentrivia/ui/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:opentrivia/models/question.dart';
import 'package:opentrivia/resources/api_provider.dart';

import 'error.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

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
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Select a category to start the quiz",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width >
                                  1000
                              ? 7
                              : MediaQuery.of(context).size.width > 600 ? 5 : 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      delegate: SliverChildBuilderDelegate(
                        _buildCategoryItem,
                        childCount: categories.length,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () {
        //_categoryPressed(context, category);

        _startQuiz(category);
      },
      shape: CircleBorder(
        side: BorderSide.none
        //borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,//Colors.grey.shade800,
      textColor: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) SizedBox(height: 5.0),
          AutoSizeText(
            category.name,

            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
          ),
        ],
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
    setState(() {
      //processing=true;
    });
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
    setState(() {
      //processing=false;
    });
  }
}

