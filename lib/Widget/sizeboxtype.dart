import 'package:flutter/cupertino.dart';
import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';

SizedBox mysizeboxheight(double taille) {
  return SizedBox(
    height: getProportionateScreenHeight(taille),
  );
}

SizedBox mysizeboxWidth(double taille) {
  return SizedBox(
    height: getProportionateScreenWidth(taille),
  );
}



