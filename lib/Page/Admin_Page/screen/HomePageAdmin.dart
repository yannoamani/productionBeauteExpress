import 'dart:convert';
import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/allReservation.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/annule.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/reservationToday.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/ReservProchain.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/RservTraite.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/reservationAdmin/reservation_en_cours.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/Login_page/login_page.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/Page/Utilisateur/screen/ecranPrincipal/compte.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Home_Admin extends StatefulWidget {
  const Home_Admin({super.key});

  @override
  State<Home_Admin> createState() => _Home_AdminState();
}

class _Home_AdminState extends State<Home_Admin> {
  late String? nom = '';
  int num = 0;
  Future<void> GetInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('nom');
    });
    print(nom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 9,
          onDestinationSelected: (int index) {
            setState(() {
              num = index;
            });
          },
          selectedIndex: num,
          destinations: [
            NavigationDestination(
              selectedIcon: FaIcon(
                CupertinoIcons.home,
                color: textStyleUtils().getPrimaryColor(),
              ),
              icon: FaIcon(
                CupertinoIcons.home,
                color: Colors.black,
              ),
              label: 'Home',
            ),
            NavigationDestination(
                selectedIcon: FaIcon(
                  CupertinoIcons.square_list,
                  color: textStyleUtils().getPrimaryColor(),
                ),
                icon: FaIcon(
                  CupertinoIcons.square_list,
                  color: Colors.black,
                ),
                label: 'Historiques'),
            NavigationDestination(
              selectedIcon: FaIcon(
                FontAwesomeIcons.user,
                color: textStyleUtils().getPrimaryColor(),
              ),
              icon: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
              label: 'Compte',
            ),
          ]),
      body: navig(num),
    );
  }
}

Widget navig(int index) {
  switch (index) {
    case 0:
      return const firstPage();
    case 1:
      return const HistoriqueAdmin();

    case 2:
      return const Compte();

    default:
      return const ReservationTraite();
  }
}

class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  List reservationPourAjourdhui = [];

  Future<void> mesReservationPourAjourdui() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationAdminOdui");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        reservationPourAjourdhui = result['data'];
      });
    } else {
      message(context, '${response.statusCode}', Colors.red);
    }
  }

  List mesreservationsValider = [];
  Future<void> mesReservationValider() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationAdminValide");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    // print(response.body);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        mesreservationsValider = result['data'];
      });
    } else {
      message(context, "${response.statusCode}", Colors.red);
    }
  }

  List mesReservationAvenir = [];
  Future<void> mesReservationsAvenir() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("reservationAdminAvenir");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.get('token')}'));
    // print(response.body);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        mesReservationAvenir = result['data'];
      });
    } else {
      print("error ${response.body}");
    }
  }

  List mesReservationAnnuler = [];
  Future<void> mesReservationsAnnuler() async {
    // final prefs = await SharedPreferences.getInstance();

    // var url = monurl("reservationAdminExpirer");
    // final uri = Uri.parse(url);
    // final response =
    //     await http.get(uri, headers: header('${prefs.get('token')}'));
    // // print(response.body);
    // final result = jsonDecode(response.body);
    // setState(() {
    //   mesReservationAnnuler = result['data'];
    // });
  }

  List reservationTodayof = [];
  bool isLoading = false;

  Future<void> reservationsencours() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminEnCours');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));

    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);

      setState(() {
        reservationTodayof = resultat['data'];
        isLoading = resultat['status'];
      });
    } else {
      message(context, "Erreur ${response.statusCode}", Colors.red);
    }
    // print(reservationToday);
  }

  String? nom = '';
  String? email = '';
  Future getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('name');
      email = prefs.getString("email");
    });
    print("$nom");
  }

  bool tester = true;
  @override
  void initState() {
    // TODO: implement initState
    mesReservationPourAjourdui();
    mesReservationsAvenir();
    mesReservationValider();
    mesReservationsAnnuler();
    getPrefs();
    reservationsencours();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return chargementPage(titre: "Dashbord", arrowback: true);
          } else {
            return WillPopScope(
              onWillPop: () async {
                message(context, 'Impossible de revenir', Colors.red);
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: NewBold('Dashboard', 25, Colors.black),
                  actions: [
                    PopupMenuButton(
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                  child: ListTile(
                                leading:
                                    FaIcon(FontAwesomeIcons.rightFromBracket),
                                title: NewText('Deconnexion', 15, Colors.black),
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('token');
                                  prefs.remove('name');
                                  prefs.remove('prenom');
                                  prefs.remove('phone');
                                  prefs.remove('email');
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return Login_page();
                                  }));
                                },
                              )),
                            ])
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    mesReservationPourAjourdui();
                    mesReservationsAvenir();
                    mesReservationValider();
                    mesReservationsAnnuler();
                    reservationsencours();
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NewBold(
                                            'Bienvenue $nom', 15, Colors.white),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        NewText('Operateur', 15, Colors.white),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        NewText('$email', 15, Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReservationEnCours()));
                                      },
                                      child: cardselection(
                                          MediaQuery.of(context).size.width,
                                          Icons.padding,
                                          "Reservations pour aujourd'hui",
                                          "${reservationPourAjourdhui.length}",
                                          Colors.blue,
                                          15),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    reservationEncourRs()));
                                      },
                                      child: cardselection(
                                          MediaQuery.of(context).size.width,
                                          Icons.padding,
                                          "Reservations  En cours...",
                                          "${reservationTodayof.length}",
                                          Colors.purple,
                                          15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Navigator.of(context).push(MaterialPageRoute(
                                    //         builder: (context) => historique()));
                                    //   },
                                    //   child: cardselection(
                                    //       MediaQuery.of(context).size.width,
                                    //       Icons.padding,
                                    //       "Reservations Expirées",
                                    //       '${mesReservationAnnuler.length}',
                                    //       Colors.red,
                                    //       15),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReservationProchain()));
                                      },
                                      child: cardselection(
                                          MediaQuery.of(context).size.width,
                                          Icons.padding,
                                          "Reservations à venir",
                                          '${mesReservationAvenir.length}',
                                          Colors.orange,
                                          15),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     GestureDetector(
                                //       onTap: () {
                                //         Navigator.of(context).push(MaterialPageRoute(
                                //             builder: (context) =>
                                //                 ReservationTraite()));
                                //       },
                                //       child: cardselection(
                                //           MediaQuery.of(context).size.width,
                                //           Icons.padding,
                                //           "Reservations traitées",
                                //           "${mesreservationsValider.length}",
                                //           Colors.green,
                                //           15),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            );
          }
        });
  }
}

// Reservation à venir
