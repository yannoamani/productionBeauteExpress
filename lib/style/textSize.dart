import 'dart:ui';

import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';

TextStyle  customText(Color color, double taille) {
    return TextStyle(
        fontSize: getProportionateScreenWidth(taille),
        fontFamily: 'popins',
        color: color);
  }