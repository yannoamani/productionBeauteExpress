import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class carMesresevations extends StatelessWidget {
  final String Days;
  final String chiffre;
  final String Mounth;
  final String libelle;
  final String heure;
  final String prix;
  final Callback ontap;
  final bool isEncours;
   carMesresevations(
      {required this.Days,
      required this.chiffre,
      required this.Mounth,
      required this.libelle,
      required this.heure,
      required this.prix,
      required this.ontap,
      required this.isEncours
      });

  @override
  Widget build(BuildContext context) {
    textStyleUtils Textsyutils = textStyleUtils();
    return  GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    // Couleur de l'ombre
                    spreadRadius: 5, // Étendue de l'ombre
                    blurRadius: 7, // Flou de l'ombre
                    offset: Offset(0, 3), // Décalage de l'ombre
                  ),
                ],
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Mytext("$Days ", 20, Colors.black),
                        Titre("${chiffre}", 25, Colors.black),
                        Mytext("$Mounth", 20, Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "$libelle",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Textsyutils.soustitre(Colors.black, 15),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Mytext('$heure', 15, Colors.black),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            "${prix}FCFA",
                            style: Textsyutils.soustitre(Colors.black, 15),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                 if(isEncours==true) CupertinoActivityIndicator(
                    color: Colors.indigo,
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: ontap);
  }
}
