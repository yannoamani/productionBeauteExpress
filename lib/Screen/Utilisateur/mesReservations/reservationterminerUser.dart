import 'package:flutter/cupertino.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/reservationAdmin/retour.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/Widget/retourEnArriere.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class reservationterminerUser extends StatefulWidget {
  const reservationterminerUser({super.key});

  @override
  State<reservationterminerUser> createState() =>
      _reservationterminerUserState();
}

class _reservationterminerUserState extends State<reservationterminerUser> {
  bool isloading = false;
  List reservattionTerminer = [];
  bool chargementBoutonenvoyer = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        isloading = resultat['status'];
      });
    } else {
      
      print(isloading);
    }
  }

  TextEditingController _controlCommentaire = TextEditingController();
  int rating = 0;
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

  @override
  void initState() {
    // TODO: implement initState
    reservationsfinish();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isloading == false) {
            return circleChargemnt();
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await reservationsfinish();
              },
              child: Scrollbar(
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
                        ? mesreservations('Aucune reservations Terminés')
                        : SliverList.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(height: 14);
                            },
                            itemBuilder: (context, index) {
                              final result = reservattionTerminer[index];
                              final date = result['date'];
                              DateTime _date = DateTime.parse(date);
                              String madate =
                                  DateFormat.yMMMMEEEEd('fr_FR').format(_date);

                              List photos = result['service']['photos'];
                              final result1 = photos.isEmpty
                                  ? ''
                                  : result['service']['photos'][0]['path'];
                              final Mydate = result['date'];
                              DateTime My = DateTime.parse(Mydate);
                              String Days = DateFormat.EEEE('fr_FR').format(My);
                              String Mounth =
                                  DateFormat.MMM('fr_FR').format(My);
                              String years = DateFormat.y('fr_Fr').format(My);
                              List mesNotes = result['notes'];

                              return GestureDetector(
                                  onTap: () async {
                                    //  Ce qui se passe une fois que je clique une reservation
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefs.setInt(
                                          'id_reservation', result["id"]);
                                    });

                                    print(prefs.get('id_reservation'));
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return Scaffold(
                                                appBar: AppBar(
                                                  automaticallyImplyLeading:
                                                      false,
                                                ),
                                                body: SafeArea(
                                                  // top: true,
                                                  // bottom: true,
                                                  child: CustomScrollView(
                                                    slivers: [
                                                      SliverAppBar(
                                                        // leadingWidth: 20,
                                                        // automaticallyImplyLeading: true,
                                                        leading: retour(),
                                                        expandedHeight: 300,
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
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6), // Ajustez l'opacité selon votre besoin
                                                                BlendMode
                                                                    .darken,
                                                              ),
                                                              child:
                                                                  Image.network(
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
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    "${result['service']['libelle']} ",
                                                                    style: textStyleUtils()
                                                                        .titreStyle(
                                                                            Colors.white,
                                                                            20),
                                                                  ),
                                                                ))
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
                                                                          "Terminée",
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
                                                              NewText(
                                                                  "$madate à ${result['heure']}",
                                                                  18,
                                                                  Colors.black),

                                                              NewText(
                                                                  "Durée:${result['service']['duree']}h",
                                                                  15,
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      78,
                                                                      77,
                                                                      77)),
                                                              SizedBox(
                                                                height: 10,
                                                              ),

                                                              Divider(),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              NewText(
                                                                  "Récapitulatif",
                                                                  20,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              NewText(
                                                                  "Montant",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Titre(
                                                                  '${result['montant']} FCFA',
                                                                  17,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              NewText(
                                                                  "Durée du service ",
                                                                  15,
                                                                  Colors.black),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Titre(
                                                                  'De ${result['date_debut']}  à  ${result['date_fin']}',
                                                                  17,
                                                                  Colors.black),

                                                              SizedBox(
                                                                height: 30,
                                                              ),

                                                              Divider(),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              if (mesNotes
                                                                  .isEmpty)
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      NewText(
                                                                          'Noter le service',
                                                                          20,
                                                                          Colors
                                                                              .black),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),

                                                                      EmojiFeedback(
                                                                        animDuration:
                                                                            const Duration(milliseconds: 200),
                                                                        curve: Curves
                                                                            .bounceIn,
                                                                        inactiveElementScale:
                                                                            .5,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            rating =
                                                                                value;
                                                                          });
                                                                        },
                                                                      ),
                                                                      if (rating <
                                                                          4)
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                      // ignore: unrelated_type_equality_checks

                                                                      if (rating <
                                                                          4)
                                                                        Form(
                                                                          key:
                                                                              formKey,
                                                                          child:
                                                                              TextFormField(
                                                                            style:
                                                                                textStyleUtils().curenttext(Colors.black, 25),
                                                                            controller:
                                                                                _controlCommentaire,
                                                                            // validator: (value) => (value != null && rating < 4)
                                                                            //     ? (value.isEmpty ? "Remplissez" : null)
                                                                            //     : null,
                                                                            maxLines:
                                                                                2,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              hintText: 'Laisse un commentaire',
                                                                              hintStyle: textStyleUtils().curenttext(Colors.black, 17),
                                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue, width: 1)),
                                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, width: 1)),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            50,
                                                                        child: ElevatedButton(
                                                                            style: textStyleUtils().primarybutton(textStyleUtils().getPrimaryColor()),
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
                                                                        height:
                                                                            10,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                height: 10,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5,
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
                                              // color: Colors.grey
                                              //     .withOpacity(
                                              //         0.5), // Couleur de l'ombre
                                              spreadRadius:
                                                  1, // Étendue de l'ombre
                                              // blurRadius:
                                              //     7, // Flou de l'ombre
                                              // offset: Offset(0,
                                              //     3), // Décalage de l'ombre
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: MediaQuery.of(context).size.width,
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
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "${result['service']['libelle']} ",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Mytext('${result['heure']}',
                                                      15, Colors.black),
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
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
            );
          }
        });
  }
}
