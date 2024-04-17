import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/screen/ecranPrincipal/Info_Service.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/promotion/promotion_page.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/screen/ecranPrincipal/acceuil.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/Widget/boutton.dart';
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

  static List getService = <String>[];
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
  textStyleUtils monStyle = textStyleUtils();

  @override
  void initState() {
    super.initState();
    connection();
    Get_Service();
  }

  bool tabvide = false;

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
       if (result.isEmpty) {
      setState(() {
        tabvide = true;
      });
      print("je suis $tabvide");
      // throw Exception('Aucun résultat trouvé.');
    }
    else{
       setState(() {
        tabvide = false;
      });

    }
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getdate(),
        builder: (context, snapshot) {
          if (getService.isEmpty) {
            return const chargementPage(titre: "", arrowback: false);
          }
          if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else {
            return Scaffold(
                backgroundColor: Colors.grey[100],
                body: WillPopScope(
                  onWillPop: () async {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (context) {
                        return acceuil();
                      }));
                      return false;
                    },
                  child: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        // SliverAppBar(
                        //   floating: true,
                        //   pinned: true,
                        //   expandedHeight: 300,
                        //   flexibleSpace: FlexibleSpaceBar(
                        //       background: Container(
                        //     height: double.infinity,
                        //     width: double.infinity,
                        //     decoration: const BoxDecoration(
                        //       image: DecorationImage(
                        //         image: AssetImage(
                        //             'assets/pexels-nothing-ahead-3230236.jpg'),
                        //         fit: BoxFit
                        //             .cover, // specify the fit property if needed
                        //       ),
                        //     ),
                        //   )),
                        // ),
                        // SliverList.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder)
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Titre("Recherche", 30, Colors.black),
                              SizedBox(
                                height: 15,
                              ),
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return <String>[];
                                  } else {
                                    return getService
                                        .where((element) => element['libelle']
                                            .toString()
                                            .toLowerCase()
                                            .contains(textEditingValue.text))
                                        .map((element) =>
                                            element['libelle'].toString())
                                        .toList();
                                  }
                                },
                                onSelected: (option) {
                                  filter(option);
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    style: monStyle.curenttext(Colors.black, 20),
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onChanged: (text) {
                                      setState(() {
                                        search.text = text;
                                      });
                                      // Mettre à jour les options ici en fonction du texte saisi
                                      // par exemple, en utilisant votre logique existante avec getService
                                    },
                                    onSubmitted: (text) {
                                      // Traitez la valeur soumise ici
                                      onFieldSubmitted();
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Rechercher...',
                                      hintStyle:
                                          monStyle.curenttext(Colors.black, 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              bouttonCustom(
                                  titre: "Recherche ",
                                  couleur: Colors.blue,
                                  tap: () {
                                    filter(search.text);
                                  }),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        )),
                        
                        tabvide==true?mesreservations("Aucun service correspondant"):
                        SliverList.separated(
                            separatorBuilder: (context, _) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: Fountservice.length,
                            itemBuilder: (context, index) {
                              final resulat = Fountservice[index];
                              final List photos = resulat['photos'];
                              final List promotions = resulat['promotions'];
                  
                              return cardRecherche(
                                  carousel: carousel,
                                  photos: photos,
                                  libelle: "${resulat['libelle']}",
                                  prix: resulat['tarif'],
                                  description: "${resulat['description']}",
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
                                      return Mesdetails(serviceData: resulat);
                                    }));
                                  });
                            }),
                      ],
                    ),
                  ),
                ));
          }
        },
      ),
    );
  }
}
