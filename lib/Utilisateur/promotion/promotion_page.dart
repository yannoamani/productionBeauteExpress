import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Utilisateur/promotion/promotion_provider.dart';
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

  Future<void> getPromotion() async {
    try {
      await promotionProvider.get_Promotion().then((value) => setState(() {
            Mes_promotions = value;
          }));
    } catch (e) {
      print("Erreur lors de la récupération des promotions : $e");
      // Gérer l'erreur de manière appropriée, par exemple afficher un message à l'utilisateur
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
    // print("${reponse.body}");
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
    return Center(
      child: FutureBuilder(
          future: Chargement(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                Mes_promotions.isEmpty) {
              return CupertinoActivityIndicator(
                radius: 26,
                color: Colors.black,
              );
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return DefaultTabController(
                length: 1,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.blue,
                    bottom: TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.blue,
                        indicatorColor: Colors.blue,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Titre('Promotions', 15, Colors.white),
                          ),
                        ]),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      Scrollbar(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Titre('Promotions', 25, Colors.black),
                            ),
                            SliverList.separated(
                                itemCount: Mes_promotions.length,
                                itemBuilder: (context, index) {
                                  final result = Mes_promotions[index];
                                  final date = result['date_debut'];
                                  final date1 = result['date_fin'];
                                  final pourc = result['pourcentage'];
                                  DateTime My = DateTime.parse(date);
                                  DateTime My1 = DateTime.parse(date1);
                                  String dateDeb =
                                      DateFormat.yMMMEd('fr_FR').format(My);
                                  String dateFin =
                                      DateFormat.yMMMEd('fr_FR')
                                          .format(My1);

                                  return GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            //  color: Colors.black,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(9),
                                              bottomRight: Radius.circular(9),
                                            )),
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                    // color: Colors.red,
                                                    height: 150,
                                                    width: double.infinity,
                                                    child: Image.asset(
                                                      "assets/sales.png",
                                                      fit: BoxFit.cover,
                                                      height: 80,
                                                      width: 80,
                                                    )

                                                    // Image.network(
                                                    //   ImgDB(
                                                    //       'public/image/${result['service']['photos'][0]['path']}'),
                                                    //   fit: BoxFit.cover,
                                                    //   width: 80,
                                                    //   height: 80,
                                                    // ),
                                                    ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    color: Colors.blue,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        "${result['pourcentage']}%",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            '${result['service']['libelle']}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   color: Colors.blue,
                                                        //   child: Padding(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //             .all(2.0),
                                                        //     child: Text(
                                                        //       '${result['objet']}',
                                                        //       style: TextStyle(
                                                        //           fontSize: 15,
                                                        //           color: Colors
                                                        //               .white,
                                                        //           fontWeight:
                                                        //               FontWeight
                                                        //                   .bold),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          '${result['cost']} FCFA',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${result['service']['tarif']} FCFA',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 15,
                                                        color: Colors.grey,
                                                        decorationColor:
                                                            Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Mytext(
                                                            ' Du $dateDeb  au  $dateFin ',
                                                            12,
                                                            Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      promotions(result['id']);
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          // isScrollControlled: true,
                                          elevation: 8,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Scaffold(
                                              appBar: AppBar(
                                                backgroundColor: Colors.white,
                                              ),
                                              body: SingleChildScrollView(
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Titre(
                                                              '${result['objet']}',
                                                              20,
                                                              Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      // Titre(
                                                      //   '',
                                                      //   18,
                                                      //   Colors.black,
                                                      // ),
                                                      Mytext(
                                                          '  ${result['description']} Avec $pourc% ',
                                                          15,
                                                          Colors.black),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  );
                                },
                                separatorBuilder: ((context, index) => SizedBox(
                                      height: 10,
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: 15));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 15));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
