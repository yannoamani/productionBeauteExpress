import 'dart:async';
import 'dart:convert';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/Widget/cardCoupons.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/promotion/promotion_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class allCOupons extends StatefulWidget {
  const allCOupons({super.key});

  @override
  State<allCOupons> createState() => _allCOuponsState();
}

class _allCOuponsState extends State<allCOupons> {
  List Coupons = [];
  List Info_coupon = [];
  bool chargement = false;
  Future dataSreen() async {
    promotionprovider.getCAllCoupons().then((value) => setState(() {
          Coupons = value;
          chargement = true;
        }));

    print(Coupons);
  }

  Future getCAllCoupons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl("couponsClient");
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header("${prefs.getString('token')}"));
      final resultat = jsonDecode(response.body);
      print('$resultat');

      if (response.statusCode == 200) {
        setState(() {
          chargement = true;
        });
        if (!resultat['status']) {
          message(context, 'Aucune donnée', Colors.red);
        } else {
          message(context, "J'ai des données", Colors.blue);
          setState(() {
            Coupons = resultat['data'];
            chargement = true;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    getCAllCoupons();
    super.initState();
  }

  Promotion_provider promotionprovider = Promotion_provider();
  @override
  Widget build(BuildContext context) {
    textStyleUtils textstyle = textStyleUtils();
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (chargement == false) {
            return chargementPage(titre: "Mes coupons", arrowback: true);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Mes Coupons",
                  textAlign: TextAlign.center,
                  style: textstyle.titreStyle(Colors.black, 20),
                ),
              ),
              body: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    Coupons.isEmpty
                        ? mesreservations("Aucun coupon trouvé")
                        : SliverList.separated(
                            itemCount: Coupons.length,
                            separatorBuilder: (context, index) {
                              return const  SizedBox(
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              final result = Coupons[index];
                              String date = result['expiration'];
                              DateTime conver = DateTime.parse(date);
                              String newDate =
                                  DateFormat.yMMMMEEEEd('fr_FR').format(conver);
                              return cardCoupons(
                                  status: result['status'],
                                  code: result['code'],
                                  expiration: newDate,
                                  pourcentage: result['pourcentage']);
                            },
                          )
                  ],
                ),
              ),
            );
          }
        });
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
