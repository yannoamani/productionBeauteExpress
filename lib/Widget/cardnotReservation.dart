import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

class cardNotReservation extends StatelessWidget {
  const cardNotReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
              spreadRadius: 1,
              // blurRadius: 7,
              // offset: Offset(0, 3), // Décalage de l'ombre
            ),
          ],
          borderRadius: BorderRadius.circular(10)),

            width: MediaQuery.of(context).size.width ,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Mytext("Aucune réservation pour aujourd'hui", 20, Colors.black)
              ],
            ),
    );
  }
}
