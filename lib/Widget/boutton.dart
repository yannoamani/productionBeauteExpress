import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class bouttonCustom extends StatelessWidget {
  final String titre;
  final Color couleur;
  final Callback tap;
  const bouttonCustom(
      {required this.titre, required this.couleur, required this.tap});

  @override
  Widget build(BuildContext context) {
    textStyleUtils styleButton = textStyleUtils();
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          style: styleButton.primarybutton(Color(0xFFAE8F29)),
          onPressed: tap,
          child: Mytext("$titre", 20, Colors.white)),
    );
  }
}
