import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:opentrivia/view/pages/home.dart';
import 'package:opentrivia/view/widgets/buttonSplashScreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin{

  double _scale;
  AnimationController _controller;
  Timer _timer;


  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(
        milliseconds: 200,), lowerBound: 0.0, upperBound: 0.1,)
      ..addListener(() {
        setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffA770FF),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/126.jpg"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height/2,
              ),
              Center(
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,

                  child: Transform.scale(
                    scale: _scale,
                    child:  animatedButtonUI,
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }


  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();

    _timer = new Timer(const Duration(milliseconds: 200), () {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    });

  }
}