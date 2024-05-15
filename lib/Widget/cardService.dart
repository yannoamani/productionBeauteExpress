import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class cardService extends StatelessWidget {
  final String photos;
  final String libelle;
  final String tarif;
  final int moyenne;
  final Callback onTap;
  const cardService(
      {required this.photos,
      required this.libelle,
      required this.tarif,
      required this.moyenne,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Container(
          width: 300,
          height: 300,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenSize(10),
                    vertical: getProportionateScreenSize(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      Text(
                        libelle,

                        style: textStyleUtils()
                            .curenttext(Colors.black, 15)
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Set the maximum number of lines to 1,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Titre(' ${tarif} FCFA', 17, Colors.black)),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Container(
                        child: Row(
                          children: [
                            for (var i = 0; i < 5; i++)
                              FaIcon(
                                i < moyenne
                                    ? FontAwesomeIcons.solidStar
                                    : FontAwesomeIcons.star,
                                color:
                                    i < moyenne ? Colors.amber : Colors.black,
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
      ),
      onTap: onTap,
    );
    ;
  }
}
