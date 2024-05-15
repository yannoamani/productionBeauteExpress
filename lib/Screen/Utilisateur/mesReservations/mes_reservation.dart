import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/reservationAvenirUser.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/reservationEncoursUser.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/reservationPass%C3%A9eUser.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/reservationPourAujourdhuiUser.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/reservationterminerUser.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
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

  List reservationRecent = [];

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
      print(response.body);
      final result = jsonDecode(response.body);

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

  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // reservationAvenir();
    reservationsfinish();
    // reservationsToday();
    // reservationRecente();

    _tabController = TabController(length: 5, vsync: this);
    // ReservationDejaPasser();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (isLoading == true) {
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
                                style: textstyle.curenttext(Colors.black, 15)),
                          ),
                          Tab(
                            child: Text("Aujourd'hui",
                                style: textstyle.curenttext(Colors.black, 15)),
                          ),
                          Tab(
                              child: Text("Terminée",
                                  style:
                                      textstyle.curenttext(Colors.black, 15))),
                          Tab(
                            child: Text("A venir",
                                style: textstyle.curenttext(Colors.black, 15)),
                          ),
                          Tab(
                            child: Text("Passée",
                                style: textstyle.curenttext(Colors.black, 15)),
                          ),
                        ]),
                  ),
                  body: SafeArea(
                    child: TabBarView(controller: _tabController, children: [
                      // ici c'est la page de la liste des reservations en cours
                      reservationEncoursUser(),

                      // La liste des reservations pour aujourd'hui
                      reservationPourAujourdui(),

                      // reservation terminée
                      reservationterminerUser(),

                      // reservation à venir

                      reservationAvenirUser(),

                      // Icic represente le card des  reservation passées
                      reservatonPasseUser()
                    ]),
                  ),
                ));
          }
        });
  }
}
