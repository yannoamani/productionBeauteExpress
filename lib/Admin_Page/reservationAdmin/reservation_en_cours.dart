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

class reservationEncourRs extends StatefulWidget {
  const reservationEncourRs({super.key});

  @override
  State<reservationEncourRs> createState() => _reservationEncourRsState();
}

class _reservationEncourRsState extends State<reservationEncourRs> {
  List reservationToday = [];
  bool isLoading = false;
// ignore: non_constant_identifier_names
  Future<void> reservationsToday() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminEnCours');
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
    try {
      final prefs = await SharedPreferences.getInstance();
      var url = monurl("reservationsvalider/$id");
      final uri = Uri.parse(url);
      final reponse = await http.post(uri,
          body: jsonEncode({'status': "Valider"}),
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
      } else {
        message(context, '${reponse.body}', Colors.red);
      
      }
    } catch (e) {
      print(e);
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
          message(context, "${reponse.statusCode}", Colors.red);
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
            return  Scaffold(
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
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      // backgroundColor: Colors.blue,
                      centerTitle: true,
                      title: FittedBox(
                          child:
                              Titre("Reservations en cours", 15, Colors.black)),
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
                                title: NewBold('$nom   ', 15, Colors.black),
                                subtitle: NewText('Depuis  ${resultats['date_debut']}', 15, Colors.black),
                                trailing: CupertinoActivityIndicator(color: Colors.indigo,),
                                onTap: () async {
                                  print("${resultats['id']}");
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    prefs.setInt(
                                        'id_valid_reservation', resultats['id']);
                                  });
                                  showModalBottomSheet(
                
                                      //  backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      // isDismissible: true,
                                      elevation: 8,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Scaffold(
                                          appBar: AppBar(),
                                          bottomNavigationBar: BottomAppBar(
                                            color: Colors.transparent,
                                            child: Container(
                                              // height: 50,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.blue),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  onPressed: () async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                
                                                    print(
                                                        "${prefs.get('id_valid_reservation')}");
                                                    validerReservation(prefs.getInt(
                                                        'id_valid_reservation')!);
                                                    reservationsToday();
                                                  },
                                                  child: Mytext('TERMINER', 17,
                                                      Colors.white)),
                                            ),
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
                                                    Container(
                                                        height: 100,
                                                        // width: dou,
                                                        child: const Center(
                                                            child:
                                                                CircularBadgeAvatar(
                                                          circleBgColor:
                                                              Colors.orangeAccent,
                                                          icon: FontAwesomeIcons
                                                              .spinner,
                                                        ))),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    // Card(
                                                    //   color:
                                                    //      Colors.purple,
                                                    //   child: ListTile(
                
                                                    //     title: Center(
                                                    //         child: NewBold(
                                                    //             '$status',
                                                    //             20,
                                                    //             Colors.white)),
                                                    //   ),
                                                    // ),
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
                                                          FontAwesomeIcons.user),
                                                      title: NewText('$nom ', 15,
                                                          Colors.black),
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
                                                      title: NewText('$email', 15,
                                                          Colors.black),
                                                    ),
                                                    Divider(),
                                                    ListTile(
                                                      leading: circlecard(
                                                          FontAwesomeIcons.phone),
                                                      title: NewText('$phone', 15,
                                                          Colors.black),
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
                                                            'Debut  ${resultats['date_debut']}',
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
                                                          FontAwesomeIcons.clock),
                                                      title: NewText('$heure', 15,
                                                          Colors.black),
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
                                leading: 
                                CircularBadgeAvatar(
                                    circleBgColor: Colors.orangeAccent,
                                    icon: FontAwesomeIcons.spinner,
                                  )
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
