import 'dart:math';

import 'package:flutter/material.dart';

const Color kColorWhite = Color(0xFFFFFFFF);
const Color kColorBlack = Color(0xFF000000);
const Color kColorPrimary = Color(0xFF5D9257);
const Color kColorSecondary = Color(0xFF262922);
const Color kColorThird = Color(0xFF5D5D5D);
const Color kColorGrey = Color(0xFF262922);
const Color kColorInputBorder = Color(0xFFD9D9D9);
const Color kColorQuestionBorder = Color(0x335D9257);
const Color kColorLightGrey = Color.fromRGBO(93, 93, 93, 0.37);

Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}

const kEnableBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kColorInputBorder, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
const kFocusBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kColorInputBorder, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

const kEnableSearchBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kColorPrimary, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
const kFocusSearchBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kColorPrimary, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
