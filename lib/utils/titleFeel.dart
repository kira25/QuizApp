import 'package:flutter/material.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';

final state = ['Hideous', "OK", "Good"];

chooseTitle(double wp, int numberText) {
  var currText = [
    Text(state[0],
        key: Key(state[0]),
        style: TextStyle(
            fontFamily: fontSintonyBold, fontSize: wp, color: kdarklogincolor)),
    Text(state[1],
        key: Key(state[1]),
        style: TextStyle(
            fontFamily: fontSintonyBold, fontSize: wp, color: kdarklogincolor)),
    Text(state[2],
        key: Key(state[2]),
        style: TextStyle(
            fontFamily: fontSintonyBold, fontSize: wp, color: kdarklogincolor)),
  ];

  return currText[numberText];
}
