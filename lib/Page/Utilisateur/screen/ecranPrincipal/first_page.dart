import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/mesReservations/mes_reservation.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/Login_page/login_page.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/promotion/promotion_provider.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardCoupons.dart';
import 'package:gestion_salon_coiffure/Widget/cardService.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:gestion_salon_coiffure/Widget/details.dart';
import 'package:gestion_salon_coiffure/Widget/listTile.dart';
import 'package:gestion_salon_coiffure/Widget/popupButon.dart';
import 'package:gestion_salon_coiffure/Widget/reservationHomePage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../fonction/fonction.dart';
import '../../coupons/AllCoupons.dart';

class First_page extends StatefulWidget {
  const First_page({super.key});

  @override
  State<First_page> createState() => _First_pageState();
}

class _First_pageState extends State<First_page> {
  textStyleUtils textStyeCUstom = textStyleUtils(); // style de mon texte

  var nom = '';
  var token = '';
  String? Nom;
  int id = 0;
  List donne = [];
  List img = [];

  List Reservation_A_V = [];

  Future<void> ReservationAvenir() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("reservationOdui");
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${prefs.getString('token')}",
      });
      if (response.statusCode == 200) {
        final resultat = response.body;
        final json = jsonDecode(resultat);
        setState(() {
          Reservation_A_V = json['data'];
          // Nom = resultat['data']['heure'];
        });
      } else {
        // print(Reservation_A_V);
      }

      // print(Reservation_A_V);
      // print("J'ai cliqué");
    } catch (e) {
      print(e);
    }
  }

  Promotion_provider promotionProvider = Promotion_provider();
  bool isloaded = false;
  List promo = [];
  Future<void> entreprise() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var url = monurl('services');
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          donne = resultat['data'];

          isloaded = true;
        });
      } else {
        print(
            "Erreur lor de la récupération des données. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur: $error");
    }
  }

  List mesCoupons = [];

  Future<void> get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('name')!;
      token = prefs.getString('token')!;
    });
    // entreprise();
  }

  Future getCouponsActif() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("couponsClientActif");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);
      // print(resultat);
      if (response.statusCode == 200) {
        if (resultat['status']) {
          setState(() {
            mesCoupons = resultat['data'];
          });
        } else {}
        print(mesCoupons);
      } else {
        print("erreur ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getdata() async {
    await Future.delayed(
      Duration(seconds: 1),
    );

    // throw 'eroor';
    return 'super';
  }

  @override
  void initState() {
    super.initState();
    entreprise();
    get();

    ReservationAvenir();

    getCouponsActif();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: getdata(),
          builder: (context, snapshot) {
            if (isloaded == false) {
              return chargementPage(titre: "Hey $nom", arrowback: false);
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Scaffold(
                  body: WillPopScope(
                      onWillPop: () async {
                        message(context, 'Impossible de revenir', Colors.red);
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await ReservationAvenir();
                          entreprise();
                          // get();
                        },
                        child: Scrollbar(
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  backgroundColor: Colors.grey[100],
                                  title: Text.rich(TextSpan(
                                      text: "Hey",
                                      style: textStyeCUstom.titreStyle(
                                          Colors.black, 24.0),
                                      children: [
                                        TextSpan(
                                            text: ' $nom',
                                            style: textStyeCUstom.titreStyle(
                                                Colors.black, 20.0))
                                      ])),
                                  actions: [
                                    popupButton(items: [
                                      PopupMenuItem(
                                          child: CustomListTile(
                                              title: "Déconnexion",
                                              taille: 15,
                                              onTap: () async {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.remove('token');
                                                prefs.remove('name');
                                                prefs.remove('prenom');
                                                prefs.remove('phone');
                                                prefs.remove('email');
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login_page()),
                                                  (route) => false,
                                                );
                                              }))
                                    ]),
                                  ]),
                              SliverToBoxAdapter(
                                child: RefreshIndicator(
                                  strokeWidth: 4,
                                  color: const Color(0xFF0A345F),
                                  backgroundColor: Colors.white,
                                  onRefresh: () async {
                                    await ReservationAvenir();
                                    getCouponsActif();
                                    entreprise();
                                    // get();
                                  },
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          if (Reservation_A_V.isNotEmpty)
                                            Row(
                                              children: [
                                                Text(
                                                  "Mes reservations",
                                                  style:
                                                      textStyeCUstom.soustitre(
                                                          Colors.black, 20),
                                                ),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return Mes_reservations();
                                                      }));
                                                    },
                                                    child: Mytext('Voir plus',
                                                        15, Colors.blue))
                                              ],
                                            ),
                                          if (Reservation_A_V.isNotEmpty)
                                            Container(
                                                height: 122,
                                                width: double.infinity,
                                                child: ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const SizedBox(
                                                    width: 10,
                                                  ),
                                                  itemCount:
                                                      Reservation_A_V.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final result =
                                                        Reservation_A_V[index];
                                                    final date = result['date'];
                                                    DateTime My =
                                                        DateTime.parse(date);
                                                    String Days =
                                                        DateFormat.EEEE('fr_FR')
                                                            .format(My);
                                                    String Mounth =
                                                        DateFormat.MMM('fr_FR')
                                                            .format(My);

                                                    return reservationHomePage(
                                                        Days: Days,
                                                        chiffre: "${My.day}",
                                                        mounth: Mounth,
                                                        libelleService:
                                                            result['service']
                                                                ['libelle'],
                                                        heure: result['heure'],
                                                        montant:
                                                            result['montant'],
                                                        status:
                                                            result['status']);
                                                  },
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                )),
                                          if (Reservation_A_V.isNotEmpty)
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          Text(
                                            "Services",
                                            style: textStyeCUstom.titreStyle(
                                                Colors.black, 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 300,
                                            color: Colors.transparent,
                                            child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  final info = donne[index];
                                                  var photos;
                                                  var iden;
                                                  List promotion =
                                                      info['promotions'];

                                                  for (var element
                                                      in info['photos']) {
                                                    iden = element['id'];
                                                    photos = element['path'];
                                                    // print(photos);
                                                  }

                                                  return cardService(
                                                      photos: photos,
                                                      libelle:
                                                          "${info['libelle']}",
                                                      tarif: info['tarif'],
                                                      moyenne: info[
                                                          'moyenne_Services'],
                                                      onTap: () async {
                                                        final prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        setState(() {
                                                          prefs.setInt(
                                                              'id_service',
                                                              info['id']);
                                                        });
                                                        print(prefs.getInt(
                                                            'id_service'));

                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return Mesdetails(
                                                              serviceData:
                                                                  info);
                                                        }));
                                                      });
                                                },
                                                separatorBuilder:
                                                    (context, _) =>
                                                        SizedBox(width: 10),
                                                itemCount: donne.length),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          if (mesCoupons.isNotEmpty)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Mes coupons",
                                                  style:
                                                      textStyeCUstom.soustitre(
                                                          Colors.black, 20),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  allCOupons()));
                                                    },
                                                    child: Mytext('Voir plus',
                                                        15, Colors.blue))
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SliverList.builder(
                                  itemCount: mesCoupons.length,
                                  itemBuilder: (context, index) {
                                    final result = mesCoupons[index];
                                    String date = result['expiration'];
                                    DateTime conver = DateTime.parse(date);
                                    String newDate =
                                        DateFormat.yMMMMEEEEd('fr_FR')
                                            .format(conver);
                                    return cardCoupons(
                                        status: "${result['status']}",
                                        code: result['code'],
                                        expiration: newDate,
                                        pourcentage: result['pourcentage']);
                                  })
                            ],
                          ),
                        ),
                      )));
            }
          }),
    );
  }
}
