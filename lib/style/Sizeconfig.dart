import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void mySize(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    orientation = _mediaQueryData?.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight ?? 0.0;
  // Default value if null
  // 812 is the layout height that the designer used
  return (inputHeight / 820.5714285714286) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth ?? 0.0; // Default value if null
  // 375 is the layout width that the designer used
  return (inputWidth / 411.42857142857144) * screenWidth;
}

double getProportionateScreenSize(double size) {
  return (getProportionateScreenWidth(size) +
          getProportionateScreenHeight(size)) /
      2;
}
double getProportionateTextSize(double inputFontSize) {
  double screenWidth = SizeConfig.screenWidth ?? 0.0;
  // Utilisez la largeur de l'écran pour ajuster la taille de la police
  return (inputFontSize / 375.0) * screenWidth;
}

