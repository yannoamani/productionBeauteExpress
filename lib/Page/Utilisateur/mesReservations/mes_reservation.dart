import 'dart:async';
import 'dart:convert';

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/reservationToday.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardMesRservations.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:gestion_salon_coiffure/Widget/showmodalMesreservations.dart';
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
  textStyleUtils textstyle = textStyleUtils();
  List Reservation_A_V = [];
  List reservationDejaPasser = [];
  List reservattionTerminer = [];
  int rating = 0;
  bool chargBoutonannuler = false;
  bool chargementBoutonenvoyer = false;
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
    if (response.statusCode == 200) {
      setState(() {
        reservationDejaPasser = resultat['data'];
      });
    } else {
      print("${response.statusCode}");
    }

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
      print(response.body);
      // print(result['status']);

      if (response.statusCode == 200) {
        message(context, 'Note envoyé avec succès ', Colors.green);
        Navigator.of(context).pop();
        _controlCommentaire.clear();
        setState(() {
          chargementBoutonenvoyer = false;
        });
        reservationsfinish();
      } else {
        message(context, "${result['message']}", Colors.red);
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
        reservationsfinish();
        _controlCommentaire.clear();
        setState(() {
          chargementBoutonenvoyer = false;
        });
      }
    } catch (e) {
      print("Une erreur  $e");
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
        setState(() {
          chargBoutonannuler = false;
        });
        message(context, "Annuler avec succès", Colors.blue);
        reservationAvenir();

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
        builder: (context, snapshot) {
          if (isLoading == false ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const chargementPage(
                titre: "Mes reservations", arrowback: true);
          } else {
            return DefaultTabController(
                animationDuration: Duration(seconds: 2),
                length: 5,
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Title(
                        color: Colors.black,
                        child: Titre('Mes réservations', 20, Colors.black)),
                    bottom: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text("En cours",
                                style: textstyle.soustitre(Colors.black, 17)),
                          ),
                          Tab(
                            child: Text("Aujourd'hui",
                                style: textstyle.soustitre(Colors.black, 17)),
                          ),
                          Tab(
                              child: Text("Terminée",
                                  style:
                                      textstyle.soustitre(Colors.black, 17))),
                          Tab(
                            child: Text("A venir",
                                style: textstyle.soustitre(Colors.black, 17)),
                          ),
                          Tab(
                            child: Text("Passée",
                                style: textstyle.soustitre(Colors.black, 17)),
                          ),
                        ]),
                  ),
                  body: SafeArea(
                    child: TabBarView(controller: _tabController, children: [
                      // ici c'est la page de la liste des reservations en cours

                      RefreshIndicator(
                        onRefresh: () async {
                          reservationsToday();
                        },
                        child: CustomScrollView(
                          slivers: [
                            reservationToday.isEmpty
                                ? mesreservations(
                                    "Auncune réservation en cours")
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
                                      // String years =
                                      //     DateFormat.y('fr_Fr').format(My);

                                      return carMesresevations(
                                          Days: Days,
                                          chiffre: "${My.day}",
                                          Mounth: Mounth,
                                          libelle:
                                              "${result['service']['libelle']}",
                                          heure: "${result['heure']}",
                                          prix: "${result['montant']}",
                                          isEncours: false,
                                          ontap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
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
                                                              expandedHeight:
                                                                  300,
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
                                                                      Colors
                                                                          .black
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
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
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
                                                                      width:
                                                                          200,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .indigo,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            CupertinoActivityIndicator(
                                                                              radius: 15,
                                                                              color: Colors.white,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Mytext(
                                                                                "${result['status']}",
                                                                                20,
                                                                                Colors.white),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Titre(
                                                                        "$madate à ${result['heure']}",
                                                                        18,
                                                                        Colors
                                                                            .black),

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
                                                                      height:
                                                                          30,
                                                                    ),

                                                                    Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Center(
                                                                      child: NewBold(
                                                                          "Recapitulatif",
                                                                          20,
                                                                          Colors
                                                                              .black),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    NewText(
                                                                        'Montant',
                                                                        15,
                                                                        Colors
                                                                            .black),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Titre(
                                                                        '${result['montant']} F CFA',
                                                                        18,
                                                                        Colors
                                                                            .black),

                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    NewText(
                                                                        'Heure debur',
                                                                        15,
                                                                        Colors
                                                                            .black),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Titre(
                                                                        '${result['date_debut']} ',
                                                                        18,
                                                                        Colors
                                                                            .black),
                                                                    // Row(
                                                                    //   children: [

                                                                    //     Spacer(),

                                                                    //   ],
                                                                    // ),
                                                                    Divider(),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),

                                                                    Center(
                                                                      child: Text.rich(TextSpan(
                                                                          text:
                                                                              "Réf de la reservation ",
                                                                          children: [
                                                                            TextSpan(
                                                                                text: "${result['id']}",
                                                                                style: TextStyle(fontWeight: FontWeight.bold))
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
                                          });
                                    },
                                    itemCount: reservationToday.length,
                                  ),
                          ],
                        ),
                      ),

                      // La liste des reservations pour aujourd'hui

                      RefreshIndicator(
                        onRefresh: () async {
                          reservationRecente();
                        },
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.blue,
                                    //       borderRadius:
                                    //           BorderRadius.circular(10)),
                                    //   width: double.infinity,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Row(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         FaIcon(
                                    //           CupertinoIcons.today,
                                    //           color: Colors.white,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 10,
                                    //         ),
                                    //         Titre("Reservations pour aujoud'hui",
                                    //             15, Colors.white),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            reservationRecent.isEmpty
                                ? mesreservations(
                                    "Aucune réservation pour aujourd'hui")
                                : SliverList.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 15);
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
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              prefs.setInt('id_reservation',
                                                  result["id"]);
                                            });

                                            print(prefs.get('id_reservation'));
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    child: Scaffold(
                                                        appBar: AppBar(
                                                          automaticallyImplyLeading:
                                                              false,
                                                        ),
                                                        body: CustomScrollView(
                                                          slivers: [
                                                            SliverAppBar(
                                                              expandedHeight:
                                                                  300,
                                                              pinned: true,
                                                              floating: true,
                                                              leading: retour(),
                                                              flexibleSpace:
                                                                  FlexibleSpaceBar(
                                                                      background:
                                                                          Stack(
                                                                children: [
                                                                  ColorFiltered(
                                                                    colorFilter:
                                                                        ColorFilter
                                                                            .mode(
                                                                      Colors
                                                                          .black
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
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
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
                                                                      width:
                                                                          200,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.orange,
                                                                          border: Border.all(color: Colors.orange),
                                                                          // color: Colors
                                                                          //     .green,
                                                                          borderRadius: BorderRadius.circular(10)),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const FaIcon(
                                                                              CupertinoIcons.timer,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Mytext(
                                                                                "${result['status']}",
                                                                                20,
                                                                                Colors.white),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Titre(
                                                                        "$madate à ${result['heure']}",
                                                                        18,
                                                                        Colors
                                                                            .black),

                                                                    Mytext(
                                                                        "Durée:${result['service']['duree']}h",
                                                                        15,
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            78,
                                                                            77,
                                                                            77)),
                                                                    Divider(),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),

                                                                    // SizedBox(
                                                                    //   height: 20,
                                                                    // ),
                                                                    Center(
                                                                      child: Titre(
                                                                          "Récapitulatif",
                                                                          20,
                                                                          Colors
                                                                              .black),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Titre(
                                                                        'Montant',
                                                                        15,
                                                                        Colors
                                                                            .black),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Titre(
                                                                        '${result['montant']} FCFA',
                                                                        17,
                                                                        Colors
                                                                            .black),

                                                                    SizedBox(
                                                                      height:
                                                                          30,
                                                                    ),
                                                                    Center(
                                                                      child: Text.rich(TextSpan(
                                                                          text:
                                                                              "Réference du rendez-vous",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                          children: [
                                                                            TextSpan(
                                                                                text: " ${result['id']}",
                                                                                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold))
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
                                                      color: Colors.grey
                                                          .withOpacity(
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
                                                      BorderRadius.circular(
                                                          10)),
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
                      ),

                      // reservation terminée
                      RefreshIndicator(
                        onRefresh: () async {
                          await reservationsfinish();
                        },
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [SizedBox(height: 10)],
                                ),
                              ),
                            ),
                            reservattionTerminer.isEmpty
                                ? mesreservations(
                                    'Aucune reservations Terminés')
                                : SliverList.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 14);
                                    },
                                    itemBuilder: (context, index) {
                                      final result =
                                          reservattionTerminer[index];
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
                                      List mesNotes = result['notes'];

                                      return GestureDetector(
                                          onTap: () async {
                                            //  Ce qui se passe une fois que je clique une reservation
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              prefs.setInt('id_reservation',
                                                  result["id"]);
                                            });

                                            print(prefs.get('id_reservation'));
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Scaffold(
                                                        appBar: AppBar(
                                                          automaticallyImplyLeading:
                                                              false,
                                                        ),
                                                        body: SafeArea(
                                                          // top: true,
                                                          // bottom: true,
                                                          child:
                                                              CustomScrollView(
                                                            slivers: [
                                                              SliverAppBar(
                                                                // leadingWidth: 20,
                                                                // automaticallyImplyLeading: true,
                                                                leading:
                                                                    retour(),
                                                                expandedHeight:
                                                                    300,
                                                                pinned: true,
                                                                // floating: false,
                                                                flexibleSpace:
                                                                    FlexibleSpaceBar(
                                                                        background:
                                                                            Stack(
                                                                  children: [
                                                                    ColorFiltered(
                                                                      colorFilter:
                                                                          ColorFilter
                                                                              .mode(
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.6), // Ajustez l'opacité selon votre besoin
                                                                        BlendMode
                                                                            .darken,
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        ImgDB(
                                                                            '${result1}'),
                                                                        height:
                                                                            double.infinity,
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
                                                                          top:
                                                                              20,
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
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
                                                                        width:
                                                                            200,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.green,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              FaIcon(
                                                                                FontAwesomeIcons.circleCheck,
                                                                                color: Colors.white,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Mytext("Terminée", 20, Colors.white),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Titre(
                                                                          "$madate à ${result['heure']}",
                                                                          18,
                                                                          Colors
                                                                              .black),

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
                                                                        height:
                                                                            10,
                                                                      ),

                                                                      Divider(),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Center(
                                                                        child: Titre(
                                                                            "Récapitulatif",
                                                                            20,
                                                                            Colors.black),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      NewText(
                                                                          "Montant",
                                                                          15,
                                                                          Colors
                                                                              .black),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Titre(
                                                                          '${result['montant']} FCFA',
                                                                          17,
                                                                          Colors
                                                                              .black),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      NewText(
                                                                          "Durée",
                                                                          15,
                                                                          Colors
                                                                              .black),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Titre(
                                                                          '${result['date_debut']}  à  ${result['date_fin']}',
                                                                          17,
                                                                          Colors
                                                                              .black),

                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),

                                                                      Divider(),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      if (mesNotes
                                                                          .isEmpty)
                                                                        Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Center(child: Titre('Noter le service', 20, Colors.black)),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),

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
                                                                              if (rating < 4)
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                              // ignore: unrelated_type_equality_checks

                                                                              if (rating < 4)
                                                                                TextFormField(
                                                                                  controller: _controlCommentaire,
                                                                                  maxLines: 2,
                                                                                  decoration: InputDecoration(
                                                                                    hintText: 'Laisse un commentaire',
                                                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue, width: 1)),
                                                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, width: 1)),
                                                                                  ),
                                                                                ),

                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Container(
                                                                                width: double.infinity,
                                                                                height: 50,
                                                                                child: ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                          RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                        )),
                                                                                    onPressed: () async {
                                                                                      setState(() {
                                                                                        chargementBoutonenvoyer = true;
                                                                                      });

                                                                                      final prefs = await SharedPreferences.getInstance();

                                                                                      noter(prefs.getInt('id_reservation')!);
                                                                                    },
                                                                                    child: chargementBoutonenvoyer == true
                                                                                        ? SpinKitCircle(
                                                                                            color: Colors.white,
                                                                                          )
                                                                                        : Mytext('Envoyer', 20, Colors.white)),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Center(
                                                                        child: Text.rich(TextSpan(
                                                                            text:
                                                                                "Réf de la réservation",
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                            children: [
                                                                              TextSpan(text: " ${result['id']}", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold))
                                                                            ])),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ));
                                                  });
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
                                                      color: Colors.grey
                                                          .withOpacity(
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
                                                      BorderRadius.circular(
                                                          10)),
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
                                                          Mytext("$Days ", 20,
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
                                                    if (mesNotes.isEmpty)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Mytext(
                                                              "Noter la réservation",
                                                              11,
                                                              Colors.white),
                                                        ),
                                                      )
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
                      ),

                      // reservation à venir

                      RefreshIndicator(
                        onRefresh: () async {
                          await reservationAvenir();
                        },
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Reservation_A_V.isEmpty
                                ? mesreservations("Aucune réseration à venir")
                                : SliverList.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 10);
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
                                      DateTime dateactuelle = DateTime.now();
                                      DateTime troisJoursPlusTard =
                                          dateactuelle.add(Duration(days: 3));
                                      bool estInferieurTroisJours =
                                          My.isBefore(troisJoursPlusTard);

                                      return carMesresevations(
                                          Days: Days,
                                          chiffre: "${My.day}",
                                          Mounth: Mounth,
                                          libelle:
                                              "${result['service']['libelle']}",
                                          heure: "${result['heure']}",
                                          prix: "${result['montant']}",
                                          isEncours: false,
                                          ontap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    child: SafeArea(
                                                      child: Scaffold(
                                                          appBar: AppBar(
                                                            automaticallyImplyLeading:
                                                                false,
                                                          ),
                                                          body: SafeArea(
                                                            child:
                                                                CustomScrollView(
                                                              slivers: [
                                                                SliverAppBar(
                                                                  leading:
                                                                      retour(),
                                                                  expandedHeight:
                                                                      300,
                                                                  pinned: true,
                                                                  floating:
                                                                      true,
                                                                  flexibleSpace:
                                                                      FlexibleSpaceBar(
                                                                          background:
                                                                              Stack(
                                                                    children: [
                                                                      ColorFiltered(
                                                                        colorFilter:
                                                                            ColorFilter.mode(
                                                                          Colors
                                                                              .black
                                                                              .withOpacity(0.6), // Ajustez l'opacité selon votre besoin
                                                                          BlendMode
                                                                              .darken,
                                                                        ),
                                                                        child: Image
                                                                            .network(
                                                                          ImgDB(
                                                                              '${result1}'),
                                                                          height:
                                                                              double.infinity,
                                                                          width:
                                                                              double.infinity,
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
                                                                              Colors.white))
                                                                    ],
                                                                  )),
                                                                ),
                                                                SliverToBoxAdapter(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 20,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10),
                                                                    child:
                                                                        Column(
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
                                                                          width:
                                                                              200,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.orange,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                FaIcon(
                                                                                  CupertinoIcons.timer,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Mytext("${result['status']}", 20, Colors.white),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Titre(
                                                                            "$madate à ${result['heure']}",
                                                                            18,
                                                                            Colors.black),

                                                                        Mytext(
                                                                            "Durée:${result['service']['duree']}h",
                                                                            15,
                                                                            const Color.fromARGB(
                                                                                255,
                                                                                78,
                                                                                77,
                                                                                77)),
                                                                        SizedBox(
                                                                          height:
                                                                              30,
                                                                        ),
                                                                        if (estInferieurTroisJours ==
                                                                            false)
                                                                          ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              final prefs = await SharedPreferences.getInstance();
                                                                              prefs.setInt('idReservation', result['id']);
                                                                              prefs.setInt('id_service', result['service_id']);
                                                                              print(prefs.get("idReservation"));
                                                                              Navigator.push(context, CupertinoPageRoute(builder: (context) => ModifierReservation()));
                                                                            },
                                                                            leading:
                                                                                FaIcon(
                                                                              CupertinoIcons.calendar,
                                                                            ),
                                                                            title: NewBold(
                                                                                'Reprogrammez le rendez-vous',
                                                                                15,
                                                                                Colors.black),
                                                                            trailing:
                                                                                FaIcon(CupertinoIcons.right_chevron),
                                                                          ),

                                                                        Divider(),
                                                                        if (estInferieurTroisJours ==
                                                                            false)
                                                                          ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              final prefs = await SharedPreferences.getInstance();
                                                                              prefs.setInt('idReservation', result['id']);
                                                                              prefs.setInt('id_service', result['service_id']);
                                                                              print(prefs.get("idReservation"));

                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return StatefulBuilder(builder: (context, setState) {
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
                                                                                                  reservationAvenir();
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
                                                                                                  style: GoogleFonts.andadaPro(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
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
                                                                                                          style: GoogleFonts.andadaPro(),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Container(
                                                                                                        child: Text("$madate ", overflow: TextOverflow.ellipsis, style: GoogleFonts.andadaPro()),
                                                                                                      ),
                                                                                                      Text("${result['heure']}", style: GoogleFonts.andadaPro()),
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
                                                                                                Titre("Êtes-vous sûr de vouloir annuler cette réservation ? Veuillez noter que cette action est irréversible. Si vous êtes certain(e) de votre décision, veuillez confirmer. ", 15, Colors.red)
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                                  });
                                                                            },
                                                                            trailing:
                                                                                FaIcon(CupertinoIcons.right_chevron),
                                                                            leading:
                                                                                FaIcon(
                                                                              CupertinoIcons.xmark,
                                                                            ),
                                                                            title: NewBold(
                                                                                'Annuler le rendez-vous',
                                                                                15,
                                                                                Colors.black),
                                                                          ),
                                                                        if (estInferieurTroisJours ==
                                                                            false)
                                                                          Divider(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Center(
                                                                          child: NewBold(
                                                                              "Recapitulatif",
                                                                              20,
                                                                              Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Titre(
                                                                            'Montant',
                                                                            15,
                                                                            Colors.black),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Titre(
                                                                            '${result['montant']} F CFA',
                                                                            18,
                                                                            Colors.black),

                                                                        Divider(),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Center(
                                                                          child: NewBold(
                                                                              "Politique d'annulation",
                                                                              20,
                                                                              Colors.black),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              6,
                                                                        ),

                                                                        Mytext(
                                                                            "Cher(e) client(e), veuillez noter notre politique d'annulation : Annulation gratuite jusqu'à 3 jours avant la date de réservation. Après cette période, des frais peuvent s'appliquer. Pour toute assistance, n'hésitez pas à nous contacter.",
                                                                            15,
                                                                            Colors.black),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Divider(),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Center(
                                                                            child: Titre(
                                                                                "Information importante",
                                                                                20,
                                                                                Colors.black)),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        if (estInferieurTroisJours ==
                                                                            true)
                                                                          Mytext(
                                                                              "Nous vous informons qu'il n'est pas autorisé de modifier ou d'annuler cette réservation pour ce service, car votre place est déjà réservée.Veuillez nous contacter pour toute question ou assistance supplémentaire.",
                                                                              15,
                                                                              Colors.red),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Divider(),
                                                                        Center(
                                                                          child:
                                                                              Text.rich(TextSpan(text: "Réf de la reservation ", children: [
                                                                            TextSpan(
                                                                                text: "${result['id']}",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                                                                          ])),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              30,
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
                                    itemCount: Reservation_A_V.length,
                                  ),
                          ],
                        ),
                      ),

                      // Icic represente le card des  reservation passées
                      RefreshIndicator(
                        onRefresh: () async {
                          await ReservationDejaPasser();
                        },
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            reservationDejaPasser.isEmpty
                                ? mesreservations('Aucune réservation passée')
                                : SliverList.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 20);
                                    },
                                    itemBuilder: (context, index) {
                                      final result =
                                          reservationDejaPasser[index];
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

                                      return carMesresevations(
                                          Days: Days,
                                          chiffre: "${My.day}",
                                          Mounth: Mounth,
                                          libelle:
                                              "${result['service']['libelle']}",
                                          heure: "${result['heure']}",
                                          prix: "${result['montant']}",
                                          isEncours: false,
                                          ontap: () {
                                            showmodalMesreservations(
                                                BuildContext,
                                                context,
                                                "${result['service']['photos'][0]['path']}",
                                                result['service']['libelle'],
                                                "$madate",
                                                "${result['heure']}",
                                                "${result['service']['duree']}",
                                                result['montant'],
                                                '${result['id']}',
                                                "Passée");
                                          });
                                    },
                                    itemCount: reservationDejaPasser.length,
                                  ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ));
          }
        });
  }
}
