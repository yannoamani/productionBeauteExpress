import 'dart:convert';
import 'dart:ffi';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardStatut.dart';
import 'package:gestion_salon_coiffure/Widget/retourEnArriere.dart';
import 'package:gestion_salon_coiffure/Widget/textRich.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Widget/cardMesRservations.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class reservationEncoursUser extends StatefulWidget {
  const reservationEncoursUser({super.key});

  @override
  State<reservationEncoursUser> createState() => _reservationEncoursUserState();
}

class _reservationEncoursUserState extends State<reservationEncoursUser> {
  List reservationToday = [];
  bool isLoading = false;

// ignore: non_constant_identifier_names
  Future<void> reservationsToday() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationClientEnCours');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    // print(response.body);
    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);
      setState(() {
        reservationToday = resultat['data'];
        isLoading = resultat['status'];
      });
    } else {
      message(context, "${response.statusCode}", Colors.red);
    }
    // print(reservationToday);
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
            return circleChargemnt();
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                reservationsToday();
              },
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    reservationToday.isEmpty
                        ? mesreservations("Auncune réservation en cours")
                        : SliverList.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(height: 8);
                            },
                            itemBuilder: (context, index) {
                              final result = reservationToday[index];
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
                              // String years =
                              //     DateFormat.y('fr_Fr').format(My);

                              return carMesresevations(
                                  Days: Days,
                                  chiffre: "${My.day}",
                                  Mounth: Mounth,
                                  libelle: "${result['service']['libelle']}",
                                  heure: "${result['date_debut']}",
                                  prix: "${result['montant']}",
                                  isEncours: true,
                                  ontap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            child: Scaffold(
                                                appBar: AppBar(
                                                  automaticallyImplyLeading:
                                                      false,
                                                ),
                                                body: CustomScrollView(
                                                  slivers: [
                                                    SliverAppBar(
                                                      automaticallyImplyLeading:
                                                          false,
                                                      leading: retour(),
                                                      expandedHeight: 300,
                                                      pinned: true,
                                                      floating: true,
                                                      flexibleSpace:
                                                          FlexibleSpaceBar(
                                                              background: Stack(
                                                        children: [
                                                          ColorFiltered(
                                                            colorFilter:
                                                                ColorFilter
                                                                    .mode(
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.6),
                                                              BlendMode.darken,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              ImgDB(
                                                                  '${result1}'),
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Mytext(
                                                                  "${result['service']['libelle']} ",
                                                                  25,
                                                                  Colors.white))
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
                                                            cardStatut(
                                                                couleur: Colors
                                                                    .indigo,
                                                                monicon:
                                                                    const CupertinoActivityIndicator(
                                                                  radius: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                indice:
                                                                    "${result['status']}"),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            NewText(
                                                                "$madate à ${result['heure']}",
                                                                18,
                                                                Colors.black),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            NewText(
                                                                "Durée du service: ${result['service']['duree']}h",
                                                                15,
                                                                Colors.black),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            NewText(
                                                                "Récapitulatif",
                                                                20,
                                                                Colors.black),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            NewText(
                                                                'Montant :',
                                                                15,
                                                                Colors.black),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            NewBold(
                                                                '${result['montant']} F CFA',
                                                                18,
                                                                Colors.black),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            NewText(
                                                                'Commencé à :',
                                                                15,
                                                                Colors.black),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Titre(
                                                                '${result['date_debut']} ',
                                                                18,
                                                                Colors.black),
                                                            const Divider(),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Center(
                                                              child: textRich(
                                                                  titre:
                                                                      "Réf de la reservation : ",
                                                                  soustitre:
                                                                      "${result['id']}"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        });
                                  });
                            },
                            itemCount: reservationToday.length,
                          ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
