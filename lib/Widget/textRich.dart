import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class textRich extends StatelessWidget {
  final String titre;
  final String soustitre;
  
  const textRich({required this.titre, required this.soustitre});

  @override
  Widget build(BuildContext context) {
    textStyleUtils customStyle = textStyleUtils();
    return Text.rich(TextSpan(
        text: "$titre",
        style: GoogleFonts.poppins(fontSize: 15),
        // style: customStyle.titreStyle(Colors.black, 15),
        children: [
          TextSpan(
              text: "$soustitre",
              style: customStyle.curenttext(Colors.black, 18))
        ]));
  }
}
