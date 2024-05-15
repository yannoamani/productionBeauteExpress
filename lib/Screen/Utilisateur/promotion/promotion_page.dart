import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/screen/ecranPrincipal/acceuil.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardMesPromotions.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:gestion_salon_coiffure/Widget/textRich.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/promotion/promotion_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Promotion_page extends StatefulWidget {
  const Promotion_page({super.key});

  @override
  State<Promotion_page> createState() => _Promotion_pageState();
}

class _Promotion_pageState extends State<Promotion_page>
    with TickerProviderStateMixin {
  Promotion_provider promotionProvider = Promotion_provider();
  List Coupons = [];
  Map Info_coupon = {};
  int taille = 0;
  bool char = false;
  List Mes_promotions = [];
  late final TabController _tabController;
  bool chargemnt = false;

  Future<void> getPromotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("promotions");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);

      setState(() {
        Mes_promotions = resultat['data'];
        chargemnt = resultat['status'];
      });

      // print(Mes_promotions);
      print(response.statusCode);
    } catch (e) {
      print("Erreur $e");
    }
  }

  Future Chargement() async {
    // while (Coupons.isEmpty || Mes_promotions.isEmpty) {
    await Future.delayed(const Duration(seconds: 1));
    // }
  }

  Future<void> promotions(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("promotions/$id");
    final uri = Uri.parse(url);
    final reponse =
        await http.get(uri, headers: header("${prefs.getString('token')}"));
    print("${reponse.statusCode}");
    getPromotion();
  }

  int nombre = 1;
  Future<void> promotionNonlu() async {
    promotionProvider.getPromotions().then((value) {
      return setState(() {
        nombre = value;
      });
    });
    print(nombre);
  }

  int? mataille;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    getPromotion();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textStyleUtils customStyle = textStyleUtils();
    return Center(
      child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (chargemnt == false) {
              return chargementPage(titre: "Promotions", arrowback: false);
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return DefaultTabController(
                length: 1,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: customStyle.getPrimaryColor(),
                        indicatorColor: customStyle.getPrimaryColor(),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Titre('Promotions', 25, Colors.black),
                          ),
                        ]),
                  ),
                  body: WillPopScope(
                    onWillPop: () async {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (context) {
                        return acceuil();
                      }));
                      return false;
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Scrollbar(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getPromotion();
                            },
                            child: CustomScrollView(
                              slivers: [
                                const SliverToBoxAdapter(
                                    child: SizedBox(
                                  height: 15,
                                )),
                                Mes_promotions.isEmpty
                                    ? mesreservations("Aucune promotion touvée")
                                    : SliverList.separated(
                                        itemCount: Mes_promotions.length,
                                        itemBuilder: (context, index) {
                                          final result = Mes_promotions[index];
                                          final date = result['date_debut'];
                                          final date1 = result['date_fin'];
                                          //  final pourc = result['pourcentage'];
                                          DateTime My = DateTime.parse(date);
                                          DateTime My1 = DateTime.parse(date1);
                                          String dateDeb =
                                              DateFormat.yMMMEd('fr_FR')
                                                  .format(My);
                                          String dateFin =
                                              DateFormat.yMMMEd('fr_FR')
                                                  .format(My1);

                                          return cardPromotions(
                                              photos:
                                                  "${result['service']['photos'][0]['path']}",
                                              pourcentage:
                                                  "${result['pourcentage']}",
                                              libelle:
                                                  "${result['service']['libelle']}",
                                              prix: result['service']['tarif'],
                                              dateDeb: dateDeb,
                                              dateFin: dateFin,
                                              flag: result['flag'],
                                              tap: () {
                                                promotions(result['id']);

                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    // isScrollControlled: true,
                                                    elevation: 8,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Scaffold(
                                                        appBar: AppBar(
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                        body:
                                                            SingleChildScrollView(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                    child: Titre(
                                                                        "Détails sur la promotion",
                                                                        18,
                                                                        Colors
                                                                            .black)),
                                                                const SizedBox(
                                                                  height: 25,
                                                                ),

                                                                textRich(
                                                                    titre:
                                                                        "Libelle : ",
                                                                    soustitre: result[
                                                                            'service']
                                                                        [
                                                                        'libelle']),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                textRich(
                                                                    titre:
                                                                        "Objet : ",
                                                                    soustitre:
                                                                        result[
                                                                            'objet']),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),

                                                                textRich(
                                                                    titre:
                                                                        "Prix : ",
                                                                    soustitre:
                                                                        "${double.parse(result['service']['tarif']) - int.parse(result['cost'])}"),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),

                                                                textRich(
                                                                    titre:
                                                                        "Date : ",
                                                                    soustitre:
                                                                        "Du $dateDeb au $dateFin")

                                                                //      Container(
                                                                //   decoration: BoxDecoration(
                                                                //       borderRadius:
                                                                //           BorderRadius
                                                                //               .circular(
                                                                //                   5),
                                                                //       border: Border.all(
                                                                //           color: Colors
                                                                //               .grey)),
                                                                //   child: Padding(
                                                                //     padding:
                                                                //         const EdgeInsets
                                                                //             .all(
                                                                //             4.0),
                                                                //     child: Text(
                                                                //       '${double.parse(result['service']['tarif']) - int.parse(result['cost'])} FCFA',
                                                                //       style: GoogleFonts
                                                                //           .openSans(
                                                                //         fontSize:
                                                                //             15,
                                                                //         fontWeight:
                                                                //             FontWeight
                                                                //                 .bold,
                                                                //       ),
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              });
                                        },
                                        separatorBuilder: ((context, index) =>
                                            SizedBox(
                                              height: 10,
                                            )))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
