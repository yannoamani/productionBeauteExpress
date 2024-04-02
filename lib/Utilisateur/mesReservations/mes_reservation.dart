import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module_reservation/Modifier_ma_reservation.dart';

class Mes_reservations extends StatefulWidget {
  const Mes_reservations({super.key});

  @override
  State<Mes_reservations> createState() => _Mes_reservationsState();
}

class _Mes_reservationsState extends State<Mes_reservations>
    with TickerProviderStateMixin {
  List Reservation_A_V = [];
  List reservationDejaPasser = [];
  List reservattionTerminer = [];
  int rating = 0;
  bool Rating = false;
  Future<void> reservationsfinish() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationClientValide");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);
      setState(() {
        reservattionTerminer = resultat['data'];
      });
    } else {
      print(response.body);
    }
  }

  Future<void> reservationAvenir() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      Reservation_A_V = resultat['data'];
    });
    // print(Reservation_A_V);
  }

  Future<void> ReservationDejaPasser() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationPasser");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationDejaPasser = resultat['data'];
    });
    // print(reservationDejaPasser);
  }

  List reservationRecent = [];
  Future<void> reservationRecente() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationOdui");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    final resultat = jsonDecode(response.body);
    setState(() {
      reservationRecent = resultat['data'];
    });
    print(reservationRecent);
  }

  Future<String> getdata() async {
    await Future.delayed(Duration(seconds: 1));

    return 'thow';
  }

  bool isLoading = false;
  TextEditingController _controlCommentaire = TextEditingController();

  Future<void> noter(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var Url = monurl('notes');
      final uri = Uri.parse(Url);
      final response = await http.post(uri,
          body: jsonEncode({
            'reservation_id': id,
            'rate': rating,
            'user_id': prefs.getInt('id'),
            'commentaire': _controlCommentaire.text
          }),
          headers: header("${prefs.get('token')}"));
      final result = jsonDecode(response.body);
      // print(result['status']);

      if (response.statusCode == 200) {
        message(context, 'Note envoyé avec succès ', Colors.green);
        Navigator.of(context).pop();
        _controlCommentaire.clear();
      } else {
        message(context, "${result['message']}", Colors.red);
        Navigator.of(context).pop();
             Navigator.of(context).pop();
        _controlCommentaire.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  List reservationToday = [];

// ignore: non_constant_identifier_names
  Future<void> reservationsToday() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationClientEnCours');
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
        message(context, "Annuler avec succès", Colors.blue);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
      } else {
        message(context, '${resultat['message']}', Colors.red);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        reservationAvenir();
      }
    } catch (e) {
      print("Erreur lors de la réservation: ${e}");
    }
    print('Je marche');
  }

  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationAvenir();
    reservationsfinish();
    reservationsToday();
    reservationRecente();

    _tabController = TabController(length: 5, vsync: this);
    ReservationDejaPasser();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (context, snashot) {
          if (isLoading == false) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                  child: CupertinoActivityIndicator(
                radius: 25,
              )),
            );
          } else {
            return DefaultTabController(
                animationDuration: Duration(seconds: 2),
                length: 5,
                child: Scaffold(
                  appBar: AppBar(
                    title: Title(
                        color: Colors.black,
                        child: Titre('Reservations', 15, Colors.black)),
                    bottom: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Mytext('En cours', 15, Colors.black),
                          ),
                          Tab(
                            child: Mytext("Pour aujourd'hui", 15, Colors.black),
                          ),
                          Tab(
                            child: Mytext('Termineés', 15, Colors.black),
                          ),
                          Tab(
                            child: NewText('A venir', 15, Colors.black),
                          ),
                          Tab(
                            child: Mytext('Passées', 15, Colors.black),
                          ),
                        ]),
                  ),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      await reservationAvenir();
                      await reservationsfinish();
                      await ReservationDejaPasser();
                    },
                    child: TabBarView(controller: _tabController, children: [
                      // ici c'est la page de la liste des reservations en cours
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.spinner,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Titre("Reservations  En cours ", 15,
                                              Colors.white),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          reservationToday.isEmpty
                              ? aucunRdv()
                              : SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final result = reservationToday[index];
                                    final date = result['date'];
                                    DateTime _date = DateTime.parse(date);
                                    String madate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(_date);

                                    List photos = result['service']['photos'];
                                    final result1 = photos.isEmpty
                                        ? ''
                                        : result['service']['photos'][0]
                                            ['path'];
                                    final Mydate = result['date'];
                                    DateTime My = DateTime.parse(Mydate);
                                    String Days =
                                        DateFormat.EEEE('fr_FR').format(My);
                                    String Mounth =
                                        DateFormat.MMM('fr_FR').format(My);
                                    String years =
                                        DateFormat.y('fr_Fr').format(My);

                                    return GestureDetector(
                                      // Voici le card de la liste des reservation à venir
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.5), // Couleur de l'ombre
                                                  spreadRadius:
                                                      5, // Étendue de l'ombre
                                                  blurRadius:
                                                      7, // Flou de l'ombre
                                                  offset: Offset(0,
                                                      3), // Décalage de l'ombre
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      Mytext("$Days", 20,
                                                          Colors.black),
                                                      Titre("${My.day}", 25,
                                                          Colors.black),
                                                      Mytext("$Mounth", 20,
                                                          Colors.black),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "${result['service']['libelle']}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Mytext(
                                                          '${result['date_debut']}',
                                                          15,
                                                          Colors.black),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          "${result['montant']}FCFA",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CupertinoActivityIndicator(
                                                  color: Colors.indigo,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        //  Ce qui se passe une fois que je clique une reservation

                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                child: Scaffold(
                                                    body: CustomScrollView(
                                                  slivers: [
                                                    SliverAppBar(
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
                                                                      0.6), // Ajustez l'opacité selon votre besoin
                                                              BlendMode.darken,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              ImgDB(
                                                                  'public/image/${result1}'),
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
                                                              child: NewBold(
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
                                                            // SizedBox(
                                                            //   height: 20,),
                                                            Container(
                                                              width: 200,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .indigo,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    CupertinoActivityIndicator(
                                                                      radius:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Mytext(
                                                                        "${result['status']}",
                                                                        20,
                                                                        Colors
                                                                            .white),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Titre(
                                                                "$madate à ${result['heure']}",
                                                                18,
                                                                Colors.black),

                                                            Mytext(
                                                                "Durée:${result['service']['duree']}h",
                                                                15,
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    78,
                                                                    77,
                                                                    77)),
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
                                                            NewBold(
                                                                "Recapitulatif",
                                                                15,
                                                                Colors.black),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Titre(
                                                                    'Total',
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                                Spacer(),
                                                                Titre(
                                                                    '${result['montant']} F CFA',
                                                                    18,
                                                                    Colors
                                                                        .black),
                                                              ],
                                                            ),
                                                            Divider(),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                            Center(
                                                              child: Text.rich(
                                                                  TextSpan(
                                                                      text:
                                                                          "Réf de la reservation ",
                                                                      children: [
                                                                    TextSpan(
                                                                        text:
                                                                            "${result['id']}",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold))
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
                                      },
                                    );
                                  },
                                  itemCount: reservationToday.length,
                                ),
                        ],
                      ),
                      // La liste des reservations pour aujourd'hui
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            CupertinoIcons.today,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Titre("Reservations pour aujoud'hui",
                                              15, Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                          reservationRecent.isEmpty
                              ? aucunRdv()
                              : SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final result = reservationRecent[index];
                                    final date = result['date'];
                                    DateTime _date = DateTime.parse(date);
                                    String madate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(_date);

                                    List photos = result['service']['photos'];
                                    final result1 = photos.isEmpty
                                        ? ''
                                        : result['service']['photos'][0]
                                            ['path'];
                                    final Mydate = result['date'];
                                    DateTime My = DateTime.parse(Mydate);
                                    String Days =
                                        DateFormat.EEEE('fr_FR').format(My);
                                    String Mounth =
                                        DateFormat.MMM('fr_FR').format(My);
                                    String years =
                                        DateFormat.y('fr_Fr').format(My);

                                    return GestureDetector(
                                        onTap: () async {
                                          //  Ce qui se passe une fois que je clique une reservation
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          setState(() {
                                            prefs.setInt(
                                                'id_reservation', result["id"]);
                                          });

                                          print(prefs.get('id_reservation'));
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: Scaffold(
                                                      body: CustomScrollView(
                                                    slivers: [
                                                      SliverAppBar(
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
                                                              child:
                                                                  Image.network(
                                                                ImgDB(
                                                                    'public/image/${result1}'),
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: NewBold(
                                                                    "${result['service']['libelle']} ",
                                                                    25,
                                                                    Colors
                                                                        .white))
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
                                                              Container(
                                                                width: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .orange),
                                                                        // color: Colors
                                                                        //     .green,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      FaIcon(
                                                                        FontAwesomeIcons
                                                                            .spinner,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Mytext(
                                                                          "${result['status']}",
                                                                          20,
                                                                          Colors
                                                                              .black),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Titre(
                                                                  "$madate à ${result['heure']}",
                                                                  18,
                                                                  Colors.black),

                                                              Mytext(
                                                                  "Durée:${result['service']['duree']}h",
                                                                  15,
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      78,
                                                                      77,
                                                                      77)),
                                                              SizedBox(
                                                                height: 30,
                                                              ),

                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Titre(
                                                                  "Récapitulatif",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Titre(
                                                                      'Total',
                                                                      15,
                                                                      Colors
                                                                          .black),
                                                                  Spacer(),
                                                                  Titre(
                                                                      '${result['montant']} FCFA',
                                                                      20,
                                                                      Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Center(
                                                                child: Text.rich(TextSpan(
                                                                    text:
                                                                        "Réference du rendez-vous",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              " ${result['id']}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold))
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
                                        },
                                        // Voici le card de la liste des reservation à venir
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        0.5), // Couleur de l'ombre
                                                    spreadRadius:
                                                        5, // Étendue de l'ombre
                                                    blurRadius:
                                                        7, // Flou de l'ombre
                                                    offset: Offset(0,
                                                        3), // Décalage de l'ombre
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Mytext("$Days", 20,
                                                            Colors.black),
                                                        Titre("${My.day}", 25,
                                                            Colors.black),
                                                        Mytext("$Mounth", 20,
                                                            Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "${result['service']['libelle']} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Mytext(
                                                            '${result['heure']}',
                                                            15,
                                                            Colors.black),
                                                        FittedBox(
                                                          child: Titre(
                                                              '${result['montant']}FCFA',
                                                              15,
                                                              Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: reservationRecent.length,
                                ),
                        ],
                      ),

                      // reservation terminée
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.circleCheck,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Titre("Reservations validées", 15,
                                              Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                          reservattionTerminer.isEmpty
                              ? aucunRdv()
                              : SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final result = reservattionTerminer[index];
                                    final date = result['date'];
                                    DateTime _date = DateTime.parse(date);
                                    String madate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(_date);

                                    List photos = result['service']['photos'];
                                    final result1 = photos.isEmpty
                                        ? ''
                                        : result['service']['photos'][0]
                                            ['path'];
                                    final Mydate = result['date'];
                                    DateTime My = DateTime.parse(Mydate);
                                    String Days =
                                        DateFormat.EEEE('fr_FR').format(My);
                                    String Mounth =
                                        DateFormat.MMM('fr_FR').format(My);
                                    String years =
                                        DateFormat.y('fr_Fr').format(My);

                                    return GestureDetector(
                                        onTap: () async {
                                          //  Ce qui se passe une fois que je clique une reservation
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          setState(() {
                                            prefs.setInt(
                                                'id_reservation', result["id"]);
                                          });

                                          print(prefs.get('id_reservation'));
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: Scaffold(
                                                      body: CustomScrollView(
                                                    slivers: [
                                                      SliverAppBar(
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
                                                              child:
                                                                  Image.network(
                                                                ImgDB(
                                                                    'public/image/${result1}'),
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: NewBold(
                                                                    "${result['service']['libelle']} ",
                                                                    25,
                                                                    Colors
                                                                        .white))
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
                                                              Container(
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      FaIcon(
                                                                        FontAwesomeIcons
                                                                            .circleCheck,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Mytext(
                                                                          "${result['status']}",
                                                                          20,
                                                                          Colors
                                                                              .white),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Titre(
                                                                  "$madate à ${result['heure']}",
                                                                  18,
                                                                  Colors.black),

                                                              Mytext(
                                                                  "Durée:${result['service']['duree']}h",
                                                                  15,
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      78,
                                                                      77,
                                                                      77)),
                                                              SizedBox(
                                                                height: 30,
                                                              ),

                                                              ListTile(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      // isScrollControlled: true,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return StatefulBuilder(
                                                                            builder: (context, setState) =>
                                                                                Scaffold(
                                                                                  backgroundColor: Colors.white,
                                                                                  body: Center(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(16),
                                                                                      child: SingleChildScrollView(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Titre('Comment avez-vous rouvé la qualité de cette prestation?', 15, Colors.black),
                                                                                            SizedBox(
                                                                                              height: 5,
                                                                                            ),
                                                                                            Mytext("Votre reponse est anonyme.Elle permet à l'entrprise d'ameliorer votre expérience", 12, const Color.fromARGB(255, 66, 65, 65)),
                                                                                            EmojiFeedback(
                                                                                              animDuration: const Duration(milliseconds: 300),
                                                                                              curve: Curves.bounceIn,
                                                                                              inactiveElementScale: .5,
                                                                                              onChanged: (value) {
                                                                                                setState(() {
                                                                                                  rating = value;
                                                                                                });
                                                                                                if (rating < 3) {
                                                                                                  setState(() {
                                                                                                    Rating = true;
                                                                                                  });
                                                                                                }
                                                                                                print(Rating);
                                                                                              },
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 5,
                                                                                            ),
                                                                                            // ignore: unrelated_type_equality_checks
                                                                                            rating < 4
                                                                                                ? TextFormField(
                                                                                                    controller: _controlCommentaire,
                                                                                                    maxLines: 2,
                                                                                                    decoration: InputDecoration(
                                                                                                      hintText: 'Laisse un commentaire',
                                                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue, width: 1)),
                                                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, width: 1)),
                                                                                                    ),
                                                                                                  )
                                                                                                : Text(""),
                                                                                            SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                ElevatedButton(
                                                                                                    style: ButtonStyle(
                                                                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                          RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                          ),
                                                                                                        )),
                                                                                                    onPressed: () {
                                                                                                      Navigator.of(context).pop();
                                                                                                    },
                                                                                                    child: Mytext('Pas maintenant', 15, Colors.blue)),
                                                                                                ElevatedButton(
                                                                                                    style: ButtonStyle(
                                                                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                          RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                                          ),
                                                                                                        )),
                                                                                                    onPressed: () async {
                                                                                                      final prefs = await SharedPreferences.getInstance();

                                                                                                      noter(prefs.getInt('id_reservation')!);
                                                                                                    },
                                                                                                    child: Mytext('Envoyer', 15, Colors.white))
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                      });
                                                                },
                                                                title: NewBold(
                                                                    'Evaluer la prestation',
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                                subtitle: NewText(
                                                                    "Vôtre réponse est anonyme , Elle permet au service de s'ameliorer.",
                                                                    13,
                                                                    Colors
                                                                        .black),
                                                                leading: FaIcon(
                                                                    CupertinoIcons
                                                                        .star),
                                                              ),
                                                              Divider(),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Titre(
                                                                  "Récapitulatif",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Titre(
                                                                      'Total',
                                                                      15,
                                                                      Colors
                                                                          .black),
                                                                  Spacer(),
                                                                  Titre(
                                                                      '${result['montant']} FCFA',
                                                                      20,
                                                                      Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Center(
                                                                child: Text.rich(TextSpan(
                                                                    text:
                                                                        "Réf de la réservation",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              " ${result['id']}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold))
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
                                        },
                                        // Voici le card de la liste des reservation à venir
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        0.5), // Couleur de l'ombre
                                                    spreadRadius:
                                                        5, // Étendue de l'ombre
                                                    blurRadius:
                                                        7, // Flou de l'ombre
                                                    offset: Offset(0,
                                                        3), // Décalage de l'ombre
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Mytext("$Days", 20,
                                                            Colors.black),
                                                        Titre("${My.day}", 25,
                                                            Colors.black),
                                                        Mytext("$Mounth", 20,
                                                            Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "${result['service']['libelle']} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Mytext(
                                                            '${result['heure']}',
                                                            15,
                                                            Colors.black),
                                                        FittedBox(
                                                          child: Titre(
                                                              '${result['montant']}FCFA',
                                                              15,
                                                              Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: reservattionTerminer.length,
                                ),
                        ],
                      ),

                      // reservation à venir
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.diagramNext,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Titre("Reservations  à venir ", 15,
                                              Colors.white),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Reservation_A_V.isEmpty
                              ? aucunRdv()
                              : SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final result = Reservation_A_V[index];
                                    final date = result['date'];
                                    DateTime _date = DateTime.parse(date);
                                    String madate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(_date);

                                    List photos = result['service']['photos'];
                                    final result1 = photos.isEmpty
                                        ? ''
                                        : result['service']['photos'][0]
                                            ['path'];
                                    final Mydate = result['date'];
                                    DateTime My = DateTime.parse(Mydate);
                                    String Days =
                                        DateFormat.EEEE('fr_FR').format(My);
                                    String Mounth =
                                        DateFormat.MMM('fr_FR').format(My);
                                    String years =
                                        DateFormat.y('fr_Fr').format(My);

                                    return GestureDetector(
                                        onTap: () {
                                          //  Ce qui se passe une fois que je clique une reservation
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: Scaffold(
                                                      body: CustomScrollView(
                                                    slivers: [
                                                      SliverAppBar(
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
                                                              child:
                                                                  Image.network(
                                                                ImgDB(
                                                                    'public/image/${result1}'),
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: NewBold(
                                                                    "${result['service']['libelle']} ",
                                                                    25,
                                                                    Colors
                                                                        .white))
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
                                                              Container(
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .orange,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      FaIcon(
                                                                        FontAwesomeIcons
                                                                            .spinner,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Mytext(
                                                                          "${result['status']}",
                                                                          20,
                                                                          Colors
                                                                              .white),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Titre(
                                                                  "$madate à ${result['heure']}",
                                                                  18,
                                                                  Colors.black),

                                                              Mytext(
                                                                  "Durée:${result['service']['duree']}h",
                                                                  15,
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      78,
                                                                      77,
                                                                      77)),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
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
                                                                  print(prefs.get(
                                                                      "idReservation"));
                                                                  Navigator.push(
                                                                      context,
                                                                      CupertinoPageRoute(
                                                                          builder: (context) =>
                                                                              ModifierReservation()));
                                                                },
                                                                leading: FaIcon(
                                                                  CupertinoIcons
                                                                      .calendar,
                                                                ),
                                                                title: NewBold(
                                                                    'Reprogrammez le rendez-vous',
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                                trailing: FaIcon(
                                                                    CupertinoIcons
                                                                        .right_chevron),
                                                              ),

                                                              Divider(),
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
                                                                  print(prefs.get(
                                                                      "idReservation"));
                                                                  // Navigator.push(
                                                                  //     context,
                                                                  //     CupertinoPageRoute(
                                                                  //         builder: (context) =>
                                                                  //             ModifierReservation()));

                                                                  showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return Scaffold(
                                                                          appBar:
                                                                              AppBar(),
                                                                          body:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    "Souhaitez-vous vraiment annuler?",
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  ListTile(
                                                                                    leading: Container(
                                                                                      height: 80,
                                                                                      width: 80,
                                                                                      child: Image.network(ImgDB("public/image/$result1")),
                                                                                    ),
                                                                                    title: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          child: Text(
                                                                                            "${result['service']['libelle']}",
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          child: Text(
                                                                                            "$madate ",
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                        Text("${result['heure']}"),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 25,
                                                                                  ),
                                                                                  boutton(context, false, Colors.black, "Oui, j'annule", () {
                                                                                    annulerReservatons();
                                                                                    reservationAvenir();
                                                                                  })
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                trailing: FaIcon(
                                                                    CupertinoIcons
                                                                        .right_chevron),
                                                                leading: FaIcon(
                                                                  CupertinoIcons
                                                                      .xmark,
                                                                ),
                                                                title: NewBold(
                                                                    'Annuler le rendez-vous',
                                                                    15,
                                                                    Colors
                                                                        .black),
                                                              ),
                                                              Divider(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              NewBold(
                                                                  "Recapitulatif",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Titre(
                                                                      'Total',
                                                                      15,
                                                                      Colors
                                                                          .black),
                                                                  Spacer(),
                                                                  Titre(
                                                                      '${result['montant']} F CFA',
                                                                      18,
                                                                      Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                              Divider(),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              NewBold(
                                                                  "Politique d'annulation",
                                                                  17,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 6,
                                                              ),

                                                              Center(
                                                                child:
                                                                    Text.rich(
                                                                  TextSpan(
                                                                      text:
                                                                          "Veuillez éviter d'annuler  dans un delais de 48 heures avant votre rendez-vous",
                                                                      children: [
                                                                        // TextSpan(
                                                                        //     text:
                                                                        //         " ${result['id']}",
                                                                        //     style: GoogleFonts.andadaPro(
                                                                        //         fontSize: 15,
                                                                        //         color: Colors.black,
                                                                        //         fontWeight: FontWeight.bold))
                                                                      ]),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Center(
                                                                child: Text.rich(
                                                                    TextSpan(
                                                                        text:
                                                                            "Réf de la reservation ",
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "${result['id']}",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold))
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
                                        },
                                        // Voici le card de la liste des reservation à venir
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        0.5), // Couleur de l'ombre
                                                    spreadRadius:
                                                        5, // Étendue de l'ombre
                                                    blurRadius:
                                                        7, // Flou de l'ombre
                                                    offset: Offset(0,
                                                        3), // Décalage de l'ombre
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Mytext("$Days", 20,
                                                            Colors.black),
                                                        Titre("${My.day}", 25,
                                                            Colors.black),
                                                        Mytext("$Mounth", 20,
                                                            Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "${result['service']['libelle']}",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Mytext(
                                                            '${result['heure']}',
                                                            15,
                                                            Colors.black),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            "${result['montant']}FCFA",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: Reservation_A_V.length,
                                ),
                        ],
                      ),

                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.compass,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Titre("Reservations passées", 15,
                                              Colors.white),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          reservationDejaPasser.isEmpty
                              ? aucunRdv()
                              : SliverList.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 8);
                                  },
                                  itemBuilder: (context, index) {
                                    final result = reservationDejaPasser[index];
                                    final date = result['date'];
                                    DateTime _date = DateTime.parse(date);
                                    String madate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(_date);

                                    List photos = result['service']['photos'];
                                    final result1 = photos.isEmpty
                                        ? ''
                                        : result['service']['photos'][0]
                                            ['path'];
                                    final Mydate = result['date'];
                                    DateTime My = DateTime.parse(Mydate);
                                    String Days =
                                        DateFormat.EEEE('fr_FR').format(My);
                                    String Mounth =
                                        DateFormat.MMM('fr_FR').format(My);
                                    String years =
                                        DateFormat.y('fr_Fr').format(My);

                                    return GestureDetector(
                                        onTap: () {
                                          //  Ce qui se passe une fois que je clique une reservation
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  child: Scaffold(
                                                      body: CustomScrollView(
                                                    slivers: [
                                                      SliverAppBar(
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
                                                              child:
                                                                  Image.network(
                                                                ImgDB(
                                                                    'public/image/${result1}'),
                                                                height: double
                                                                    .infinity,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: NewBold(
                                                                    "${result['service']['libelle']} ",
                                                                    25,
                                                                    Colors
                                                                        .white))
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
                                                              Container(
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      FaIcon(
                                                                        FontAwesomeIcons
                                                                            .spinner,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Mytext(
                                                                          "${result['status']}",
                                                                          20,
                                                                          Colors
                                                                              .red),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Titre(
                                                                  "$madate à ${result['heure']}",
                                                                  18,
                                                                  Colors.black),

                                                              Mytext(
                                                                  "Durée:${result['service']['duree']}h",
                                                                  15,
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      78,
                                                                      77,
                                                                      77)),
                                                              SizedBox(
                                                                height: 30,
                                                              ),

                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              NewBold(
                                                                  "Recapitulatif",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Titre(
                                                                      'Total',
                                                                      15,
                                                                      Colors
                                                                          .black),
                                                                  Spacer(),
                                                                  Titre(
                                                                      '${result['montant']} F CFA',
                                                                      18,
                                                                      Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                              Divider(),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Center(
                                                                child: Text.rich(
                                                                    TextSpan(
                                                                        text:
                                                                            "Réf de la reservavtion ",
                                                                        children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "${result['id']}",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold))
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
                                        },
                                        // Voici le card de la liste des reservation à venir
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(
                                                        0.5), // Couleur de l'ombre
                                                    spreadRadius:
                                                        5, // Étendue de l'ombre
                                                    blurRadius:
                                                        7, // Flou de l'ombre
                                                    offset: Offset(0,
                                                        3), // Décalage de l'ombre
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      children: [
                                                        Mytext("$Days", 20,
                                                            Colors.black),
                                                        Titre("${My.day}", 25,
                                                            Colors.black),
                                                        Mytext("$Mounth", 20,
                                                            Colors.black),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "${result['service']['libelle']} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Mytext(
                                                            '${result['heure']}',
                                                            15,
                                                            Colors.black),
                                                        FittedBox(
                                                          child: Titre(
                                                              '${result['montant']}FCFA',
                                                              15,
                                                              Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                  itemCount: reservationDejaPasser.length,
                                ),
                        ],
                      )
                    ]),
                  ),
                ));
          }
        });
  }
}
