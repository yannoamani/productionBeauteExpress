import 'dart:convert';
import 'package:circular_badge_avatar/circular_badge_avatar.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueAdmin extends StatefulWidget {
  const HistoriqueAdmin({super.key});

  @override
  State<HistoriqueAdmin> createState() => _HistoriqueAdminState();
}

class _HistoriqueAdminState extends State<HistoriqueAdmin> {
  List getReservations = [];
  bool isLoading = false;
  Future<void> myreservation() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var url = monurl('reservationOperateur');
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header('${prefs.getString('token')}'));

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          getReservations = resultat['data'];
          isLoading = resultat['status'];
        });
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myreservation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return chargementPage(titre: "Historiques", arrowback: false);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Mytext("Historiques", 20, Colors.black),
              ),
              body: Scrollbar(
                interactive: true,
                child: CustomScrollView(
                  slivers: [
                    SliverList.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemCount: getReservations.length,
                        itemBuilder: (context, index) {
                          final resultats = getReservations[index];
                          final nom = resultats['user']['nom'];
                          final prenom = resultats['user']['prenom'];
                          final email = resultats['user']['email'];
                          final phone = resultats['user']['phone'];
                          String date = resultats['date'];
                          String heure = resultats['heure'];
                          final montant = resultats['montant'];

                          final status = resultats['status'];
                          DateTime Convert = DateTime.parse(date);

                          String NewDate =
                              DateFormat.yMMMEd('fr_FR').format(Convert);
                          return ListTile(
                            title: Text("$nom"),
                            subtitle: Text("$prenom"),
                            trailing: Column(
                              children: [
                                FaIcon(
                                    status == "Expirer"
                                        ? FontAwesomeIcons.xmark
                                        : status == "Annuler"
                                            ? FontAwesomeIcons.xmark
                                            : FontAwesomeIcons.circleCheck,
                                    size: 30,
                                    color: status == "Expirer"
                                        ? Colors.red
                                        : status == "Annuler"
                                            ? Colors.red
                                            : Colors.green

                                    // Couleur par défaut pour le cas "spinner"
                                    ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "${status == "Annuler" ? "Annulée" : status == "Expirer" ? "Expiree" : "Traitée"}"),
                              ],
                            ),
                            leading: CircularBadgeAvatar(
                              iconPosition: 32,
                              iconColor: status == "Expirer"
                                  ? Colors.red
                                  : status == "Annuler"
                                      ? Colors.red
                                      : Colors.green,

                              icon: status == "Expirer"
                                  ? FontAwesomeIcons.xmark
                                  : status == "Annuler"
                                      ? FontAwesomeIcons.xmark
                                      : FontAwesomeIcons.circleCheck,

                              /// [if you want to use asset image]
                              // assetImage: "assets/images/asset_image.png",
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  //  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  // isDismissible: true,
                                  elevation: 8,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        automaticallyImplyLeading: false,
                                      ),
                                      body: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                retour(),
                                                Container(
                                                    height: 100,
                                                    // width: dou,
                                                    child: Center(
                                                        child:
                                                            CircularBadgeAvatar(
                                                      circleBgColor:
                                                          Colors.orangeAccent,
                                                      icon: status == "Expirer"
                                                          ? FontAwesomeIcons
                                                              .xmark
                                                          : status == "Annuler"
                                                              ? FontAwesomeIcons
                                                                  .xmark
                                                              : FontAwesomeIcons
                                                                  .circleCheck,
                                                    ))),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Center(
                                                          child: Titre(
                                                              'Informations sur le client',
                                                              20,
                                                              Colors.black)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .user),
                                                        title: NewText('$nom ',
                                                            15, Colors.black),
                                                        subtitle: NewText(
                                                            '$prenom',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .envelope),
                                                        title: NewText('$email',
                                                            15, Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .phone),
                                                        title: NewText('$phone',
                                                            15, Colors.black),
                                                      ),
                                                      Divider(),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Center(
                                                          child: Titre(
                                                              "Informations sur la reservation",
                                                              20,
                                                              Colors.black)),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .briefcase),
                                                        title: NewText(
                                                            '${resultats['service']['libelle']}',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .calendarDay),
                                                        title: NewText(
                                                            '$NewDate',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .clock),
                                                        title: NewText('$heure',
                                                            15, Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                          leading: circlecard(
                                                              FontAwesomeIcons
                                                                  .hourglass),
                                                          title: Text.rich(
                                                              TextSpan(
                                                                  text: 'De ',
                                                                  children: [
                                                                TextSpan(
                                                                    text:
                                                                        "${resultats['date_debut']}",
                                                                    style: GoogleFonts.andadaPro(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                TextSpan(
                                                                  text: " à",
                                                                ),
                                                                TextSpan(
                                                                    text:
                                                                        " ${resultats['date_fin']}",
                                                                    style: GoogleFonts.andadaPro(
                                                                        fontWeight:
                                                                            FontWeight.bold))
                                                              ]))),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlecard(
                                                            FontAwesomeIcons
                                                                .moneyBill),
                                                        title: NewBold(
                                                            '${montant} FCFA',
                                                            20,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          );
                        })
                  ],
                ),
              ),
            );
          }
        });
    ;
  }
}
