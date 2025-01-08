import 'package:flutter/material.dart';
import 'package:quizsquare/view/widgets/button.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({ this.message = "There was an unknown error." });


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303F9F),
        title: Text('Error'),
        elevation: 5,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF303F9F),
              const Color(0xFF1F1147),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: Colors.white12,
              shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(message,textAlign: TextAlign.center,style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),),
                    SizedBox(height: 20.0),
                    myButton(
                      function: ()=> Navigator.pop(context),
                      buttonName: 'Try Again',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}