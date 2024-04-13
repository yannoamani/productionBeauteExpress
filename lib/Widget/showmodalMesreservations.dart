import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

Future showmodalMesreservations(BuildContext,context, String photos, String libelle,String date, String heure, String duree,String montant, String id, String statut) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: retour(),
                    expandedHeight: 300,
                    pinned: true,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                                0.6), // Ajustez l'opacité selon votre besoin
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            ImgDB('${photos}'),
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: NewBold("${libelle} ",
                                25, Colors.white))
                      ],
                    )),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 20,),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  FaIcon(CupertinoIcons.back,
                                      color: Colors.white),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Mytext("$statut", 20, Colors.white),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Titre(
                              "$date à ${heure}", 18, Colors.black),

                          Mytext("Durée:${duree}h", 15,
                              const Color.fromARGB(255, 78, 77, 77)),
                          SizedBox(
                            height: 30,
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: NewBold("Recapitulatif", 20, Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Titre('Montant', 15, Colors.black),
                          SizedBox(
                            height: 10,
                          ),
                          Titre('${montant} F CFA', 18, Colors.black),
                          // Row(
                          //   children: [

                          //     Spacer(),

                          //   ],
                          // ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text.rich(TextSpan(
                                text: "Réf de la reservavtion ",
                                children: [
                                  TextSpan(
                                      text: "$id",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ])),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      });
}
