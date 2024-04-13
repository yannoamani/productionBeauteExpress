import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class textStyleUtils {
  TextStyle titreStyle( Color color,double taille) {
    return GoogleFonts.andadaPro(
      fontSize: taille,
      color: color,
       letterSpacing: 1.0,  
      fontWeight: FontWeight.bold
    );
  }
  TextStyle soustitre( Color color,double taille) {
    return GoogleFonts.andadaPro(
      fontSize: taille,
      color: color,
       letterSpacing: 1.0,  
      fontWeight: FontWeight.bold
    );
  }
  TextStyle curenttext( Color color,double taille) {
    return GoogleFonts.andadaPro(
      fontSize: taille,
      color: color,
      //  letterSpacing: 1.0,  
      // fontWeight: FontWeight.bold
    );
  }
}
