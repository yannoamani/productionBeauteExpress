import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Utilisateur/module_reservation/Passer_Une_Reservation.dart';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class detail_service extends StatefulWidget {
  const detail_service({super.key});

  @override
  State<detail_service> createState() => _detail_serviceState();
}

class _detail_serviceState extends State<detail_service> {
  bool ic = false;
  var id = 0;
  var token = "";
  bool _isCharged = false;
  DateTime today = DateTime.now();
  // Mon future Async qui va me  permettre de recuprer le details sur le Rdv
  Map<String, dynamic> info_servie = {};
  List img = [];
  Map mespath = {};
  List promotions = [];
  final result = (Connectivity().checkConnectivity());

  // Information sur le service()
  List note = [];
  Future connection() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() {
        // tester = false;
      });
    } else {
      setState(() {
        // tester = true;
      });
    }
  }

  Future<void> get_info_service() async {
    final url = monurl('services/$id');
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        setState(() {
          info_servie = decode['data'];
          img = info_servie['photos'];
          note = info_servie['reservations'];
          promotions = info_servie['promotions'];
        });
        if (info_servie.isNotEmpty) {
          setState(() {
            _isCharged = !_isCharged;
          });
        }
        // print(info_servie);
      } else {
        // Gérez les erreurs ici
        print(
            "Erreur lors de la récupération des informations du service. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print(
          "Erreur lors de la récupération des informations du service : $error.");
    }
  }

  getid_service() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id_service')!;
      token = prefs.getString('token')!;
    });
    get_info_service();
  }

  Future getdata() async {
    // while (info_servie.isEmpty) {
    await Future.delayed(Duration(seconds: 1));
    // }
    return "error";
  }

  int page = 0;

  @override
  void initState() {
    super.initState();

    getid_service();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (info_servie.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Chargement de la page '),
                SpinKitCircle(
                  color: Colors.blue,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Scaffold(
              bottomNavigationBar: BottomAppBar(
                  child: boutton(
                      context, false, Colors.blue, "RESERVER DES MAINTENANT",
                      () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return prise_rdv();
                }));
              })),
              body: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Titre("${info_servie['libelle']}", 20, Colors.black),
                      actions: [Mytext('${page+1}/${img.length}', 15, Colors.black)],
                      pinned: true,
                      floating: true,
                      expandedHeight: 300,
                      flexibleSpace: FlexibleSpaceBar(
                        background: CarouselSlider(
                          options: CarouselOptions(
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            height: double.infinity,
                            onPageChanged: (index, reason) {
                              setState(() {
                                page = index;
                              });
                            },
                          ),
                          items: img.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                String imagePath =
                                    ImgDB("public/image/${i['path']}");
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      child: Image.network(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          AnimatedSmoothIndicator(
                              curve: Curves.bounceInOut,
                              activeIndex: page,
                              count: img.length),
                          Container(
                            color: Colors.grey[100],
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Populaire ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  NewBold('${info_servie['libelle']} ', 15,
                                      Colors.black),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Titre(
                                      '${promotions.isEmpty ? info_servie['tarif'] : info_servie['promotions'][0]['cost']} FCFA',
                                      17,
                                      Colors.black),
                                  promotions.isNotEmpty
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${info_servie['tarif']} FCFA",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.lineThrough),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  border: Border.all(
                                                      color: Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: NewBold(
                                                    "-${info_servie['promotions'][0]['pourcentage']} %",
                                                    15,
                                                    Colors.white),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text.rich(TextSpan(
                                      text: 'Durée : ',
                                      style: GoogleFonts.openSans(
                                          fontSize: 16, color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: '${info_servie['duree']}h',
                                            style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w700))
                                      ])),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("DESCRIPTION",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${info_servie["description"]}",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Titre("Avis", 15, Colors.black),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          for (var i = 0; i < 5; i++)
                                            FaIcon(
                                              i < info_servie['moyenne_Services']
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              color: i <
                                                      info_servie[
                                                          'moyenne_Services']
                                                  ? Colors.amber
                                                  : Colors.black,
                                              size: 15,
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: '  (${note.length}) vote(s)',
                                            style: TextStyle(color: Colors.black))
                                      ]),
                                    ),
                                    Divider(
                                      color: const Color.fromARGB(
                                          255, 160, 159, 159),
                                    ),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverList.builder(
                        itemCount: note.length,
                        itemBuilder: (context, index) {
                          final result = note[index];
                          String dates = result['created_at'];
                          DateTime Convert =
                              DateTime.parse(dates.toString().substring(0, 10));
                          String newdate =
                              DateFormat.yMMMMEEEEd("FR_fr").format(Convert);
                          List notes = result['notes'];
                          final mesnotes =
                              notes.isEmpty ? 'neant' : notes[0]['commentaire'];
                          final nom =
                              notes.isEmpty ? 'neant' : notes[0]['user']['nom'];
                          final prenom = notes.isEmpty
                              ? 'neant'
                              : notes[0]['user']['prenom'];
                
                          return Container(
                            color: Colors.grey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text("$mesnotes"),
                                ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                        "${nom.toString().substring(0, 1)}${prenom.toString().substring(0, 1).toUpperCase()}"),
                                  ),
                                  title: NewText(
                                      "${nom.toString().toLowerCase()},${prenom.toString().substring(0, 1).toUpperCase()}",
                                      18,
                                      Colors.black),
                                  subtitle:
                                      NewText("${newdate}", 15, Colors.black38),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      // for (var i = 0; i < result['rate']; i++)
                                      //   Icon(
                                      //     Icons.star,
                                      //     color: Colors.black,
                                      //     size: 20,
                                      //   ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: NewText("${mesnotes}", 15, Colors.black),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ));
        }
      },
    );
  }
}
