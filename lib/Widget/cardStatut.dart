import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

class cardStatut extends StatelessWidget {
  final Color couleur;
  final String indice;
  final Widget monicon;

  const cardStatut(
      {required this.couleur, required this.monicon, required this.indice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: textStyleUtils().getPrimaryColor(),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            monicon,
            SizedBox(
              width: 10,
            ),
            Mytext("${indice}", 20, Colors.white),
          ],
        ),
      ),
    );
  }
}
