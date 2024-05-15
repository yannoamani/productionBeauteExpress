import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

class reservationHomePage extends StatelessWidget {
  final String Days;
  final String chiffre;
  final String mounth;
  final String libelleService;
  final String heure;
  final String montant;
  final String status;
  const reservationHomePage({
    required this.Days,
    required this.chiffre,
    required this.mounth,
    required this.libelleService,
    required this.heure,
    required this.montant,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    textStyleUtils textstyle = textStyleUtils();
    return Container(
      decoration: BoxDecoration(
          color: textstyle.getPrimaryColor(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
              spreadRadius: 1, // Étendue de l'ombre
              blurRadius: 7, // Flou de l'ombre
              offset: Offset(0, 3), // Décalage de l'ombre
            ),
          ],
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Mytext("$Days", 20, Colors.white),
                  Titre("${chiffre}", 25, Colors.white),
                  Mytext("$mounth", 20, Colors.white),
                ],
              ),
            ),
            SizedBox(
              width: 40,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "${libelleService} ",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Mytext('${heure}', 15, Colors.white),
                  FittedBox(
                    child: Titre('${montant} FCFA', 15, Colors.white),
                  ),
                  // SizedBox(height: 5,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Mytext('${status}', 15, Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    
  }
}
