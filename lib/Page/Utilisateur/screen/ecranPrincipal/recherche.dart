import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/screen/ecranPrincipal/Info_Service.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/promotion/promotion_page.dart';
import 'package:gestion_salon_coiffure/Widget/cardRecherche.dart';
import 'package:gestion_salon_coiffure/Widget/cardScrollRecherche.dart';
import 'package:gestion_salon_coiffure/Widget/chargementPage.dart';
import 'package:gestion_salon_coiffure/Widget/details.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController search = TextEditingController();
  bool tester = true;
  int id = 0;
  bool isConnected = false;
  CarouselController carousel = CarouselController();
  Future connection() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() {
        tester = false;
      });
    } else {
      setState(() {
        tester = true;
      });
    }
  }

  String token = "";

  List getService = [];
  List Fountservice = [];

  Future<void> Get_Service() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
      Fountservice = getService;
    });
    try {
      final url = monurl('services');
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 449|qRuLLv17A9rJLil6AcWoMuiuBu8ajMglqTn5Qi9Z"
      });

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          getService = resultat['data'];
          Fountservice = getService;
        });
        if (Fountservice.isNotEmpty) {
          setState(() {
            isConnected = !isConnected;
          });
        }

        // print(response.body);
      } else {
        print(
            "Erreur lors de la récupération des données. Code d'état : ${response.statusCode}");
      }
    } catch (error) {
      print("Erreur lors de la récupération des données : $error");
    }
  }

  // La liste de tous les ervices

  Future<String> getdate() async {
    await Future.delayed(Duration(seconds: 1));

    return 'Error';
  }

  int rating = 0;

  @override
  void initState() {
    super.initState();
    connection();
    Get_Service();
  }

  void filter(String indice) {
    List result = [];
    if (indice.trim().isEmpty) {
      result = getService;
    } else {
      result = getService
          .where((element) => element['libelle']
              .toString()
              .toLowerCase()
              .contains(indice.toLowerCase()))
          .toList();
      setState(() {
        Fountservice = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getdate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              getService.isEmpty) {
            return const chargementPage(titre: "", arrowback: false);
         
          }
          if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Scrollbar(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  moncontainer("", () {}, search, filter), Au cas où je nn'arrive pas

                    Container(
                      height: 140,
                      color: Colors.blue,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 220,
                                      child: TextFormField(
                                        controller: search,
                                        onChanged: (value) {
                                          // filter(value);
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: Colors.blue,
                                            ),
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  search.clear();
                                                },
                                                icon: Icon(Icons.close)),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: 'Rechercher',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            filter(search.text);
                                          });
                                        },
                                        child: Mytext(
                                            "Recherche", 15, Colors.blue))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Container(
                                  height: 40,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        width: 10,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final resulat = getService[index];
                                      return cardRecherche1(
                                          libelle: resulat['libelle']);
                                    },
                                    itemCount: getService.length,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            separatorBuilder: (context, _) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: Fountservice.length,
                            itemBuilder: (context, index) {
                              final resulat = Fountservice[index];
                              final List photos = resulat['photos'];
                              final List promotions = resulat['promotions'];

                              // final promotion = resulat['promotions'];
                              // var photo;
                              // for (var img in photos) {
                              //   photo = img['path'];
                              //   // print(photo);
                              // }

                              return cardRecherche(
                                  carousel: carousel,
                                  photos: photos,
                                  libelle: "${resulat['libelle']}",
                                  prix: resulat['tarif'],
                                  description:"${ resulat['description']}",
                                  onTap: () async {
                                       id = resulat['id'];
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    prefs.setInt('id_service', id);
                                  });
                                  print(id);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return  Mesdetails(serviceData: resulat);
                                  }));

                                  });
                            }),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
