import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cardService extends StatelessWidget {
  final String photos;
  final String libelle;
  final String tarif;
  final int moyenne;
   final Callback onTap;
  const cardService({required this.photos,required this.libelle,required this.tarif,required this.moyenne,
  required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     
      child: Container(
        width: 300 - 60,
        height: 300 - 20,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(9),
              bottomRight: Radius.circular(9),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1,
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  boxShadow: [],
                  color: Colors.transparent,
                ),
                child: Image.network(
                  ImgDB("$photos"),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        '${libelle}',

                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Set the maximum number of lines to 1,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Titre(
                              ' ${tarif} FCFA', 13, Colors.black)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            FaIcon(
                              i < moyenne
                                  ? FontAwesomeIcons.solidStar
                                  : FontAwesomeIcons.star,
                              color: i <moyenne
                                  ? Colors.amber
                                  : Colors.black,
                              size: 15,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
    ;
  }
}
