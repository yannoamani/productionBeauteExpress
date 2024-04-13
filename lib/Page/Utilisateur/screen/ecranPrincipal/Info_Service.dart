import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/module_reservation/Passer_Une_Reservation.dart';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool voirplus = false;
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

  int mesprix = 0;
  int Pourcentage = 0;
  
  Future<void> get_info_service() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl('services/$id');
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: header('449|qRuLLv17A9rJLil6AcWoMuiuBu8ajMglqTn5Qi9Z'));

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
        } else {
          print('$mesprix');
        }
        for (var element in promotions) {
          var prix = int.parse(element['cost']);
          int pourcentage = element['pourcentage'];
          setState(() {
            mesprix += prix;
            Pourcentage += pourcentage;
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
          return Scaffold(
            appBar: AppBar(
              title: NewText("Information sur le service", 15, Colors.black),
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Titre("Chargement...", 15, Colors.black),
                  SizedBox(
                    height: 5,
                  ),
                  CupertinoActivityIndicator(
                    radius: 25,
                    color: Colors.black,
                  )
                ],
              ),
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
                // get_info_service();
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (context) {
                  return prise_rdv();
                }));
              })),
              body: SafeArea(
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leadingWidth: 20,

                        centerTitle: true,
                        title: NewBold(
                            "${info_servie['libelle']}", 15, Colors.black),

                        pinned: true,
                        // floating: true,
                        expandedHeight: 300,
                        // leading: IconButton(
                        //     onPressed: () {
                        //       print("object");
                        //     },
                        //     icon: Icon(Icons.arrow_back)),

                        flexibleSpace: FlexibleSpaceBar(
                          background: FlutterCarousel(
                            options: CarouselOptions(
                              slideIndicator: CircularSlideIndicator(),
                              autoPlay: true,

                              enableInfiniteScroll: true,
                              pageSnapping: true,

                              // autoPlayInterval: Duration(seconds: 3),
                              // autoPlayAnimationDuration:
                              //     Duration(milliseconds: 800),
                              // autoPlayCurve: Curves.fastOutSlowIn,
                              // enlargeCenterPage: true,
                              // autoPlay: true,
                              // height: double.infinity,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  page = index;
                                });
                              },
                            ),
                            items: img.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  String imagePath = ImgDB("${i['path']}");
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                            Container(
                              color: Colors.grey[100],
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.red,
                                    //       borderRadius:
                                    //           BorderRadius.circular(10)),
                                    //   child: const Padding(
                                    //     padding: const EdgeInsets.all(5),
                                    //     child: Text(
                                    //       "Populaire ",
                                    //       style: TextStyle(color: Colors.white),
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                   Text("${info_servie['libelle']}",
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                   style:const  TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900
                                   ),

                                   
                                   ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Titre(
                                        '${double.parse(info_servie['tarif']) - mesprix} FCFA',
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
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: NewBold(
                                                      "${Pourcentage} %",
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
                                      const   SizedBox(height: 5,),
                                         Container(
                                              child: Row(
                                                children: [
                                                  for (var i = 0; i < 5; i++)
                                                    FaIcon(
                                                      i <
                                                              info_servie[
                                                                  'moyenne_Services']
                                                          ? FontAwesomeIcons
                                                              .solidStar
                                                          : FontAwesomeIcons
                                                              .star,
                                                      color: i <
                                                              info_servie[
                                                                  'moyenne_Services']
                                                          ? Colors.amber
                                                          : Colors.black,
                                                      size: 15,
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Mytext("(${info_servie['moyenne_Services']})", 15, Colors.black)
                                                ],
                                              ),
                                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                   const    Text("DESCRIPTION",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    const  SizedBox(
                                        height: 10,
                                      ),
                                      if (voirplus == false)
                                        Container(
                                          child: Text(
                                            "${info_servie["description"]}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      if (voirplus == true)
                                        Text(
                                          "${info_servie["description"]}",

                                          // overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              voirplus = !voirplus;
                                            });
                                          },
                                          child: Text(
                                              "${voirplus == false ? "Voir plus" : 'Voir moins'}"))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Titre("Avis", 25, Colors.black),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    

                                      SizedBox(
                                        height: 5,
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
                            DateTime Convert = DateTime.parse(
                                dates.toString().substring(0, 10));
                            String newdate =
                                DateFormat.yMMMMEEEEd("FR_fr").format(Convert);
                            List notes = result['notes'];
                            final mesnotes = notes.isEmpty
                                ? 'Super'
                                : notes[0]['commentaire'];
                            final nom = notes.isEmpty
                                ? 'Néant'
                                : notes[0]['user']['nom'];
                            final prenom = notes.isEmpty
                                ? 'Neant'
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
                                        // radius: 30,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          "assets/pngwing.com.png",
                                          height: 30,
                                          width: 30,
                                        )),
                                    title: NewText(
                                        "$nom $prenom", 18, Colors.black),
                                    subtitle: Container(
                                      child: Row(
                                        children: [
                                          for (var i = 0; i < 5; i++)
                                            FaIcon(
                                              i < result['notes'][0]['rate']
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              color:
                                                  i < result['notes'][0]['rate']
                                                      ? Colors.amber
                                                      : Colors.black,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
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
                                    child: NewText(
                                        "${mesnotes == null ? "Génial" : mesnotes}",
                                        15,
                                        Colors.black),
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
                ),
              ));
        }
      },
    );
  }
}
