import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/module_reservation/Modifier_ma_reservation.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardMesRservations.dart';
import 'package:gestion_salon_coiffure/Widget/cardStatut.dart';
import 'package:gestion_salon_coiffure/Widget/retourEnArriere.dart';
import 'package:gestion_salon_coiffure/Widget/textRich.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class reservationPourAujourdui extends StatefulWidget {
  const reservationPourAujourdui({super.key});

  @override
  State<reservationPourAujourdui> createState() =>
      _reservationPourAujourduiState();
}

class _reservationPourAujourduiState extends State<reservationPourAujourdui> {
  List reservationRecent = [];
  bool isloading = false;
  Future<void> reservationRecente() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationOdui");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationRecent = resultat['data'];
      isloading = resultat['status'];
    });
    print(reservationRecent);
  }

 
 
  bool chargementBoutonenvoyer = false;
 

  bool chargBoutonannuler = false;
  Future<dynamic> annulerReservatons() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final url = monurl("reservations/${prefs.getInt('idReservation')}");
      final uri = Uri.parse(url);

      final response = await http.put(uri,
          body: jsonEncode({'status': 'Annuler'}),
          headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);

      // print(resultat);
      if (resultat['status']) {
        setState(() {
          chargBoutonannuler = false;
        });
        message(context, "Annuler avec succès", Colors.blue);
        reservationRecente();

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
      } else {
        message(context, '${resultat['message']}', Colors.red);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        reservationRecente();
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
    }
    print('Je marche');
  }

  @override
  void initState() {
    reservationRecente();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isloading == false) {
            return circleChargemnt();
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                reservationRecente();
              },
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    reservationRecent.isEmpty
                        ? mesreservations("Aucune réservation pour aujourd'hui")
                        : SliverList.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(height: 15);
                            },
                            itemBuilder: (context, index) {
                              final result = reservationRecent[index];
                              final date = result['date'];
                              DateTime _date = DateTime.parse(date);
                              String madate =
                                  DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                              List photos = result['service']['photos'];
                              final result1 = photos.isEmpty
                                  ? ''
                                  : result['service']['photos'][0]['path'];
                              final Mydate = result['date'];
                              DateTime My = DateTime.parse(Mydate);
                              String Days = DateFormat.EEEE('fr_FR').format(My);
                              String Mounth =
                                  DateFormat.MMM('fr_FR').format(My);
                              String heure = result['heure'];

                              String years = DateFormat.y('fr_Fr').format(My);
                              TimeOfDay montime = convertirEnTimeOfDay(heure);
                              TimeOfDay heureActuelle = TimeOfDay.now();
                              TimeOfDay troisHeuresPlusTard =
                                  ajouterHeures(heureActuelle, 3);

                              bool estInferieurTroisJours =
                                  estInferieurA(montime, troisHeuresPlusTard);

                              return carMesresevations(
                                  Days: Days,
                                  chiffre: "${My.day}",
                                  Mounth: Mounth,
                                  libelle: "${result['service']['libelle']}",
                                  heure: "$heure",
                                  prix: "${result['montant']}",
                                  isEncours: false,
                                  ontap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            child: SafeArea(
                                              child: Scaffold(
                                                  appBar: AppBar(
                                                    automaticallyImplyLeading:
                                                        false,
                                                  ),
                                                  body: SafeArea(
                                                    child: CustomScrollView(
                                                      slivers: [
                                                        SliverAppBar(
                                                          leading: retour(),
                                                          expandedHeight: 300,
                                                          pinned: true,
                                                          floating: true,
                                                          flexibleSpace:
                                                              FlexibleSpaceBar(
                                                                  background:
                                                                      Stack(
                                                            children: [
                                                              ColorFiltered(
                                                                colorFilter:
                                                                    ColorFilter
                                                                        .mode(
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.6), // Ajustez l'opacité selon votre besoin
                                                                  BlendMode
                                                                      .darken,
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  ImgDB(
                                                                      '${result1}'),
                                                                  height: double
                                                                      .infinity,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "${result['service']['libelle']} ",
                                                                      maxLines:
                                                                          1,
                                                                      style: textStyleUtils().titreStyle(
                                                                          Colors
                                                                              .white,
                                                                          20),
                                                                    ),
                                                                  ))
                                                            ],
                                                          )),
                                                        ),
                                                        SliverToBoxAdapter(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20,
                                                                    right: 10,
                                                                    left: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // SizedBox(
                                                                //   height: 20,),
                                                                cardStatut(
                                                                    couleur:
                                                                        textStyleUtils()
                                                                            .getPrimaryColor(),
                                                                    monicon:
                                                                      const   Icon(
                                                                      CupertinoIcons
                                                                          .time,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    indice:
                                                                        "En Attente"),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                NewText(
                                                                    "$madate à ${result['heure']}",
                                                                    18,
                                                                    Colors
                                                                        .black),

                                                                Mytext(
                                                                    "Durée du service :${result['service']['duree']}h",
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                if (estInferieurTroisJours ==
                                                                    false)
                                                                  ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      final prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      prefs.setInt(
                                                                          'idReservation',
                                                                          result[
                                                                              'id']);
                                                                      prefs.setInt(
                                                                          'id_service',
                                                                          result[
                                                                              'service_id']);
                                                                      print(prefs
                                                                          .get(
                                                                              "idReservation"));
                                                                      Navigator.push(
                                                                          context,
                                                                          CupertinoPageRoute(
                                                                              builder: (context) => ModifierReservation()));
                                                                    },
                                                                    leading:
                                                                        FaIcon(
                                                                      CupertinoIcons
                                                                          .calendar,
                                                                    ),
                                                                    title: NewText(
                                                                        'Reprogrammez le rendez-vous',
                                                                        18,
                                                                        Colors
                                                                            .black),
                                                                    trailing:
                                                                        FaIcon(
                                                                      CupertinoIcons
                                                                          .right_chevron,
                                                                    ),
                                                                  ),

                                                                Divider(),
                                                                if (estInferieurTroisJours ==
                                                                    false)
                                                                  ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      final prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      prefs.setInt(
                                                                          'idReservation',
                                                                          result[
                                                                              'id']);
                                                                      prefs.setInt(
                                                                          'id_service',
                                                                          result[
                                                                              'service_id']);
                                                                      print(prefs
                                                                          .get(
                                                                              "idReservation"));

                                                                      showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return StatefulBuilder(builder:
                                                                                (context, setState) {
                                                                              return Scaffold(
                                                                                bottomNavigationBar: BottomAppBar(
                                                                                    child: ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                              RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                            )),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            chargBoutonannuler = true;
                                                                                          });
                                                                                          annulerReservatons();
                                                                                          reservationRecente();
                                                                                        },
                                                                                        child: chargBoutonannuler == true
                                                                                            ? SpinKitCircle(
                                                                                                color: Colors.white,
                                                                                              )
                                                                                            : Mytext("Oui, j'annule", 20, Colors.white))),
                                                                                appBar: AppBar(),
                                                                                body: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SingleChildScrollView(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Souhaitez-vous vraiment annuler?",
                                                                                          textAlign: TextAlign.left,
                                                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        ListTile(
                                                                                          leading: Container(
                                                                                            height: 80,
                                                                                            width: 80,
                                                                                            child: Image.network(ImgDB("$result1")),
                                                                                          ),
                                                                                          title: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                child: Text(
                                                                                                  "${result['service']['libelle']}",
                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                  style: GoogleFonts.poppins(),
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                child: Text("$madate ", overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins()),
                                                                                              ),
                                                                                              Text("${result['heure']}", style: GoogleFonts.poppins()),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 25,
                                                                                        ),
                                                                                        Center(
                                                                                            child: Icon(
                                                                                          CupertinoIcons.info,
                                                                                          color: Colors.red,
                                                                                          size: 40,
                                                                                        )),
                                                                                        Mytext("Êtes-vous sûr de vouloir annuler cette réservation ? Veuillez noter que cette action est irréversible. Si vous êtes certain(e) de votre décision, veuillez confirmer. ", 15, Colors.red)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                          });
                                                                    },
                                                                    trailing: FaIcon(
                                                                        CupertinoIcons
                                                                            .right_chevron),
                                                                    leading:
                                                                        FaIcon(
                                                                      CupertinoIcons
                                                                          .xmark,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    title: NewText(
                                                                        'Annuler le rendez-vous',
                                                                        18,
                                                                        Colors
                                                                            .black),
                                                                  ),
                                                                if (estInferieurTroisJours ==
                                                                    false)
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                NewText(
                                                                    "Récapitulatif",
                                                                    20,
                                                                    Colors
                                                                        .black),

                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                NewText(
                                                                    'Montant :',
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                NewBold(
                                                                    '${result['montant']} F CFA',
                                                                    18,
                                                                    Colors
                                                                        .black),

                                                                Divider(),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                NewText(
                                                                    "Politique d'annulation",
                                                                    20,
                                                                    Colors
                                                                        .black),

                                                                SizedBox(
                                                                  height: 15,
                                                                ),

                                                                NewBold(
                                                                    "Cher(e) client(e), veuillez noter que toute annulation doit être effectuée au moins 3 heures avant l'heure prévue de votre réservation. Pour toute assistance, n'hésitez pas à nous contacter.",
                                                                    15,
                                                                    Colors.red),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),

                                                                SizedBox(
                                                                  height: 5,
                                                                ),

                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Divider(),
                                                                Center(
                                                                  child: textRich(
                                                                      titre:
                                                                          "Réference de la reservation : ",
                                                                      soustitre:
                                                                          "${result['id']}"),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          );
                                        });
                                  });
                            },
                            itemCount: reservationRecent.length,
                          ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

TimeOfDay convertirEnTimeOfDay(String heure24) {
  List<String> heureMinutes = heure24.split(':');
  int heure = int.parse(heureMinutes[0]);
  int minute = int.parse(heureMinutes[1]);
  return TimeOfDay(hour: heure, minute: minute);
}

TimeOfDay ajouterHeures(TimeOfDay heure, int heuresToAdd) {
  int newHour = (heure.hour + heuresToAdd) % 24;
  return TimeOfDay(hour: newHour, minute: heure.minute);
}

bool estInferieurA(TimeOfDay heure, TimeOfDay limite) {
  return heure.hour < limite.hour;
}
