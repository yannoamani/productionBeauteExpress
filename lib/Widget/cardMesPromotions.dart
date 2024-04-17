import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class cardPromotions extends StatelessWidget {
  final  String photos;
  final  String pourcentage;
  final  String  libelle;
  final  String  prix;
  final  String    dateDeb;
  final  String    dateFin;
  final int flag;
   final Callback tap;
  const cardPromotions({required this.photos, required this.pourcentage, required this.libelle, required this.prix, required this.dateDeb, required this.dateFin, required this.flag,required this.tap});

  @override
  Widget build(BuildContext context) {
    textStyleUtils customStyle = textStyleUtils();
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              //  color: Colors.black,
              border: Border.all(color: Colors.grey),
              borderRadius:const  BorderRadius.only(
                bottomLeft: Radius.circular(9),
                bottomRight: Radius.circular(9),
              )),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    ImgDB('$photos'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      color: customStyle.getPrimaryColor(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text("${pourcentage}%",
                            style: customStyle.curenttext(Colors.white, 20)),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              '${libelle}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    
                      Text(
                        '${prix} FCFA',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                          decorationColor: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Container(
                        child: NewBold(
                            ' Du $dateDeb  au  $dateFin ', 12, Colors.black),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      if (flag == 0)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: texte("Non lu"),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: tap
    );
    
  }
}
