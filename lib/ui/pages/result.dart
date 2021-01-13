import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
              child:
              Lottie.asset('assets/lottie/starswinner.json')
              //Lottie.asset('assets/lottie/starswinner.json'),
            )));
  }
}
