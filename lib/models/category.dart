
import 'package:flutter/material.dart';

class Category{
  final int id;
  final String name;
  final dynamic icon;
  final Color color;
  Category(this.id, this.name, this.color,{this.icon});

}
final List<Color> tileColors = [
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.indigo,
  Colors.lightBlue,
  Colors.amber,
  Colors.deepOrange,
  Colors.brown,
  Colors.red,
];


final List<Category> categories = [
  Category(9,"General Knowledge",  tileColors[0] //icon: FontAwesomeIcons.globeAsia
  ),
  /*Category(13,"Musicals & Theatres", tileColors[1] //icon: FontAwesomeIcons.theaterMasks
  ),*/
  Category(10,"Books", tileColors[2]//icon: FontAwesomeIcons.bookOpen
  ),
/*
  Category(15,"Video Games",tileColors[6] //icon: FontAwesomeIcons.gamepad
  ),*/
  Category(11,"Film",tileColors[3] //icon: FontAwesomeIcons.video
  ),
  Category(12,"Music",tileColors[4] //icon: FontAwesomeIcons.music
  ),

  Category(14,"Television", tileColors[5]//icon: FontAwesomeIcons.tv
  ),

  Category(16,"Board Games", tileColors[7]//icon: FontAwesomeIcons.chessBoard
  ),
  Category(17,"Science & Nature",tileColors[8] //icon: FontAwesomeIcons.microscope
  ),
  Category(18,"Computer",tileColors[9] //icon: FontAwesomeIcons.laptopCode
  ),
  Category(19,"Maths",tileColors[0]//icon: FontAwesomeIcons.sortNumericDown
  ),
  Category(32,"Cartoon & Animation", tileColors[3]),

  Category(20,"Mythology", tileColors[1]),
  Category(21,"Sports",tileColors[2]//icon: FontAwesomeIcons.footballBall
  ),
  Category(22,"Geography", tileColors[3]//icon: FontAwesomeIcons.mountain
  ),
  Category(23,"History",tileColors[4]// icon: FontAwesomeIcons.monument
  ),
  Category(24,"Politics", tileColors[5]),
  Category(26,"Celebrities", tileColors[7] ),
  Category(27,"Animals", tileColors[8]//icon: FontAwesomeIcons.dog
  ),
  Category(28,"Vehicles", tileColors[9]//icon: FontAwesomeIcons.carAlt
  ),
  Category(29,"Comics", tileColors[0]),
  Category(31,"Japanese Anime & Manga", tileColors[2]),
];


class Options{
  int num;
  String option;
  Options({
    required this.num,
    required this.option});
}