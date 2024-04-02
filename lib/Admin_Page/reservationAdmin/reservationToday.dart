import 'dart:convert';

import 'package:circular_badge_avatar/circular_badge_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Utilisateur/mesReservations/mes_reservation.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationEnCours extends StatefulWidget {
  const ReservationEnCours({super.key});

  @override
  State<ReservationEnCours> createState() => _ReservationEnCoursState();
}

class _ReservationEnCoursState extends State<ReservationEnCours> {
  List reservationToday = [];
  bool isLoading = false;
// ignore: non_constant_identifier_names
  Future<void> reservationsToday() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminOdui');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    // print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationToday = resultat['data'];
      isLoading = resultat['status'];
    });
    // print(reservationToday);
  }

// Voici le code pour pour valider une reservation
  Future<void> validerReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl("reservationsvalider/$id");
    final uri = Uri.parse(url);
    final reponse = await http.post(uri,
        body: jsonEncode({'status': "En Cours"}),
        headers: header('${prefs.get('token')}'));
    if (reponse.statusCode == 200) {
      final resultat = jsonDecode(reponse.body);
      if (resultat['status'] == false) {
        message(context, "${resultat['message']}", Colors.red);

        Navigator.of(context).pop();
      }
      if (resultat['status']) {
        message(context, "${resultat['message']}", Colors.green);

        Navigator.of(context).pop();
      }
    }
  }

  Future<void> annulerReservation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var url = monurl("reservationsvalider/$id");
      final uri = Uri.parse(url);
      final reponse = await http.post(uri,
          body: jsonEncode({'status': "Annuler"}),
          headers: header('${prefs.get('token')}'));
      if (reponse.statusCode == 200) {
        final resultat = jsonDecode(reponse.body);
        if (resultat['status'] == false) {
          message(context, "${resultat['message']}", Colors.red);
          Navigator.of(context).pop();
        }
        if (resultat['status']) {
          message(context, "Annuler avec succèss", Colors.green);

          Navigator.of(context).pop();
        }
      }
      print(reponse.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    reservationsToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "En cours de chargement ...",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CupertinoActivityIndicator(radius: 20),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Scrollbar(
                thickness: 20,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      // backgroundColor: Colors.blue,
                      centerTitle: true,
                      title: FittedBox(
                          child: Titre("Reservations pour aujourd'hui", 25,
                              Colors.black)),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Titre('Reservation à venir', 25, Colors.black),
                        ],
                      ),
                    ),
                    reservationToday.isNotEmpty
                        ? SliverList.separated(
                            itemCount: reservationToday.length,
                            itemBuilder: (context, index) {
                              final resultats = reservationToday[index];
                              final nom = resultats['user']['nom'];
                              final prenom = resultats['user']['prenom'];
                              final montant = resultats['montant'];
                              final email = resultats['user']['email'];
                              final phone = resultats['user']['phone'];
                              final status = resultats['status'];
                              final duree = resultats['service']["duree"];
                              final heure = resultats['heure'];
                              String date = resultats['date'];
                              DateTime Convert = DateTime.parse(date);
                              String NewDate =
                                  DateFormat.yMMMEd('fr_FR').format(Convert);
                              return ListTile(
                                title:
                                    NewText('$nom  $prenom', 15, Colors.black),
                                subtitle: NewBold('$heure ', 15, Colors.red),
                                trailing: FaIcon(FontAwesomeIcons.arrowRight),
                                onTap: () async {
                                  print("${resultats['id']}");
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    prefs.setInt('id_valid_reservation',
                                        resultats['id']);
                                  });
                                  showModalBottomSheet(

                                      //  backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      // isDismissible: true,
                                      elevation: 8,
                                      context: context,
                                      builder: (BuildContext fcontext) {
                                        return Scaffold(
                                          appBar: AppBar(),
                                          bottomNavigationBar: BottomAppBar(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 50,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors.red),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        )),
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CupertinoAlertDialog(
                                                              content: Text(
                                                                  "êtes-vous sûr d'annuler cette reservation ?"),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: NewText(
                                                                        "Non",
                                                                        15,
                                                                        Colors
                                                                            .red)),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      final prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();

                                                                      print(
                                                                          "${prefs.get('id_valid_reservation')}");
                                                                      annulerReservation(
                                                                          prefs.getInt(
                                                                              'id_valid_reservation')!);
                                                                      reservationsToday();
                                                                    },
                                                                    child: NewText(
                                                                        "Oui",
                                                                        15,
                                                                        Colors
                                                                            .blue))
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Mytext('Annuler', 15,
                                                        Colors.white)),
                                              ),
                                             
                                              Container(
                                                height: 50,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .blue),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        )),
                                                    onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CupertinoAlertDialog(
                                                              content: Text(
                                                                  "êtes-vous sûr de debuter la reservations ?"),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: NewText(
                                                                        "Non",
                                                                        15,
                                                                        Colors
                                                                            .red)),
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      final prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();

                                                                      print(
                                                                          "${prefs.get('id_valid_reservation')}");
                                                                      validerReservation(
                                                                          prefs.getInt(
                                                                              'id_valid_reservation')!);
                                                                      reservationsToday();
                                                                    },
                                                                    child: NewText(
                                                                        "Oui",
                                                                        15,
                                                                        Colors
                                                                            .blue))
                                                              ],
                                                            );
                                                          });
                                                      // final prefs =
                                                      //     await SharedPreferences
                                                      //         .getInstance();

                                                      // print(
                                                      //     "${prefs.get('id_valid_reservation')}");
                                                      // validerReservation(
                                                      //     prefs.getInt(
                                                      //         'id_valid_reservation')!);
                                                      // reservationsToday();
                                                    },
                                                    child: Mytext('Commencer',
                                                        15, Colors.white)),
                                              ),
                                            ],
                                          )),
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
                                                    Container(
                                                        height: 100,
                                                        // width: dou,
                                                        child: Center(
                                                            child:
                                                                CircularBadgeAvatar(
                                                          circleBgColor: Colors
                                                              .orangeAccent,
                                                          icon: FontAwesomeIcons
                                                              .spinner,
                                                        ))),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Center(
                                                      child: Titre(
                                                          'Informations sur le client',
                                                          20,
                                                          Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .user),
                                                      title: NewText('$nom ',
                                                          15, Colors.black),
                                                      subtitle: NewText(
                                                          '$prenom ',
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
                                                      height: 15,
                                                    ),
                                                    Center(
                                                        child: Titre(
                                                            "Informations sur la reservation",
                                                            20,
                                                            Colors.black)),
                                                    SizedBox(
                                                      height: 10,
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
                                                              .hourglass),
                                                      title: NewText(
                                                          '${resultats['service']['duree']}h',
                                                          15,
                                                          Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons
                                                              .calendarCheck),
                                                      title: NewText('$NewDate',
                                                          15, Colors.black),
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
                                                              .moneyBill),
                                                      title: NewText(
                                                          '${resultats['montant']}FCFA',
                                                          20,
                                                          Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                leading: CircularBadgeAvatar(
                                  iconPosition: 30,
                                  icon: FontAwesomeIcons.spinner,
                                  iconColor: Colors.blue,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider())
                        : aucunRdv()
                  ],
                ),
              ),
            );
          }
        });
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: 15));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 15));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}