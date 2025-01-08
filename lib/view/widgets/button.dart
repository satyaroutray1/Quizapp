
import 'package:flutter/material.dart';

 class myButton extends StatefulWidget {

  final String buttonName;
  final Function function;
  myButton({required this.buttonName, required this.function});

  @override
  _myButtonState createState() => _myButtonState();
}

class _myButtonState extends State<myButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          //color: Color(0xff36E9BA),
          onPressed: widget.function(),
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(widget.buttonName, style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                color: Colors.white
            ),),
          ),
        ),
      ),
    );
  }
}
