import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/module_reservation/Passer_Une_Reservation.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class Mesdetails extends StatefulWidget {
  final Map<String, dynamic> serviceData;
  const Mesdetails({required this.serviceData});

  @override
  State<Mesdetails> createState() => _MesdetailsState();
}

class _MesdetailsState extends State<Mesdetails> {
  bool ic = false;
  var id = 0;
  var token = "";
  //bool _isCharged = false;
  bool voirplus = false;
  DateTime today = DateTime.now();
  // Mon future Async qui va me  permettre de recuprer le details sur le Rdv

  List img = [];
  Map mespath = {};
  List promotions = [];
  bool _isLoading = true;

  // Information sur le service()
  List note = [];

  int mesprix = 0;
  int Pourcentage = 0;
  void responsapi() {
    setState(() {
      img = widget.serviceData['photos'];
      // note = widget.serviceData['reservations'];
      promotions = widget.serviceData['promotions'];
    });
    // print(note);

    if (promotions.isEmpty) {
      print("Aucune donnée");
    } else {
      for (var element in promotions) {
        var prix = int.parse(element['cost']);
        int pourcentage = element['pourcentage'];
        setState(() {
          mesprix += prix;
          Pourcentage += pourcentage;
        });
      }
    }

    // print(widget.serviceData);
  }

  Future<void> get_info_service() async {
    // final prefs = await SharedPreferences.getInstance();
    final url = monurl('services/${widget.serviceData['id']}');
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri,
          headers: header('449|qRuLLv17A9rJLil6AcWoMuiuBu8ajMglqTn5Qi9Z'));
      print("${response.body}");

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        setState(() {
          final info_service = decode['data'];
          note = info_service['reservations'];
        });
        // setState(() {
        //    info_service = decode['data'];
        //   note = info_service['reservations'];
        // });

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
    responsapi();

    get_info_service();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (widget.serviceData.isEmpty) {
          return chargementPage(
              titre: "${widget.serviceData['libelle']}", arrowback: true);
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
                  return const prise_rdv();
                }));
              })),
              body: SafeArea(
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leadingWidth: 20,

                        centerTitle: true,
                        title: NewBold("${widget.serviceData['libelle']}", 15,
                            Colors.black),

                        pinned: true,
                        // floating: true,
                        expandedHeight: 300,

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
                                    onTap: () {
                                      print("click");
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: InstaImageViewer(
                                          child: Image(
                                            image: Image.network(imagePath,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {

                                                               if (loadingProgress == null) {
              setState(() {
                _isLoading = false;
              });
              return child;
            } else {
              setState(() {
                _isLoading = true;
              });
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              );
            }
          
                                                            },
                                                             errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text('Impossible de charger l\'image');
          },

                             
                                                            )
                                                .image,
                                          ),
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
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${widget.serviceData['libelle']}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Titre(
                                        '${double.parse(widget.serviceData['tarif']) - mesprix} FCFA',
                                        17,
                                        Colors.black),
                                    promotions.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${widget.serviceData['tarif']} FCFA",
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
                                              text:
                                                  '${widget.serviceData['duree']}h',
                                              style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.w700))
                                        ])),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          for (var i = 0; i < 5; i++)
                                            FaIcon(
                                              i <
                                                      widget.serviceData[
                                                          'moyenne_Services']
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              color: i <
                                                      widget.serviceData[
                                                          'moyenne_Services']
                                                  ? Colors.amber
                                                  : Colors.black,
                                              size: 15,
                                            ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Mytext(
                                              "(${widget.serviceData['moyenne_Services']})",
                                              15,
                                              Colors.black)
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
                                      const Text("DESCRIPTION",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (voirplus == false)
                                        Container(
                                          child: Text(
                                            "${widget.serviceData["description"]}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      if (voirplus == true)
                                        Text(
                                          "${widget.serviceData["description"]}",

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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        color:
                                            Color.fromARGB(255, 160, 159, 159),
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
                            // String dates = result['created_at'];
                            // DateTime Convert = DateTime.parse(
                            //     dates.toString().substring(0, 10));
                            // String newdate =
                            //     DateFormat.yMMMMEEEEd("FR_fr").format(Convert);
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
