import 'package:flutter/cupertino.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
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
    return GoogleFonts.poppins(
        fontSize: taille,
        color: color,
        // letterSpacing: 1.0,
        fontWeight: FontWeight.bold);
  }

  TextStyle curenttext(Color color, double taille) {
    return GoogleFonts.poppins(
      fontSize: taille,
      color: color,
      //  letterSpacing: 1.0,
      // fontWeight: FontWeight.bold
    );
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
