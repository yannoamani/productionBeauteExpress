import 'package:flutter/cupertino.dart';
import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class textStyleUtils {
  TextStyle titreStyle(Color color, double taille) {
    return GoogleFonts.poppins(
        fontSize: taille,
        color: color,
        // letterSpacing: 1.0,
        fontWeight: FontWeight.bold);
  }

  TextStyle soustitre(Color color, double taille) {
    return TextStyle(fontSize: taille, fontFamily: 'popins', color: color);
  }

  TextStyle curenttext(Color color, double taille) {
    return TextStyle(
        fontSize: getProportionateScreenWidth(taille),
        fontFamily: 'popins',
        color: color);
  }

  ButtonStyle primarybutton(Color macouleur) {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(macouleur),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }

  Color getPrimaryColor() {
    return Color(0xFFAE8F29);
  }
}

Color myprimaryColor = Color(0xFFAE8F29);
