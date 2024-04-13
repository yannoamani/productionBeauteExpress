import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

class cardRecherche1 extends StatelessWidget {
  final String libelle;
  const cardRecherche1({required this.libelle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.white)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Mytext('${libelle}', 15, Colors.white),
      )),
    );
    ;
  }
}
