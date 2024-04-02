import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Admin_Page/reservationAdmin/provider_notes.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesNotes extends StatefulWidget {
  const MesNotes({super.key});

  @override
  State<MesNotes> createState() => _MesNotesState();
}

class _MesNotesState extends State<MesNotes> {
  noteProvider providernote = noteProvider();
  bool isLoading = false;
  List mesVotes = [];
  Future<void> Getnote() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl("notes");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    if (resultat['status']) {
      setState(() {
        mesVotes = resultat['data'];
        isLoading = resultat['status'];
      });
    } else {
      message(context, "${resultat['message']}", Colors.red);
    }
    print(mesVotes);
  }

  @override
  void initState() {
    // TODO: implement initState
    Getnote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:  Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chargement en cours...",
                    
                    ),
                    CupertinoActivityIndicator(
                      radius: 25,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            );
          }
          else{
            return  Scaffold(
              appBar: AppBar(
                title: Text('Mes notes'),
                actions: [Image.asset('assets/massage.png')],
              ),
              backgroundColor: Colors.grey[100],
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // ElevatedButton(
                          //     onPressed: () {
                          //       Getnote();
                          //     },
                          //     child: Text("")),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Titre('MES NOTES', 25, Colors.black),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Mytext('Mon Classement actuel', 20,
                                      Colors.black),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // CircularPercentIndicator(
                                  //   radius: 120.0,
                                  //   lineWidth: 13.0,
                                  //   animation: true,
                                  //   animationDuration: 2500,
                                  //   percent: 0.7,
                                  //   center: Titre('7.0', 20, Colors.black),
                                  //   circularStrokeCap: CircularStrokeCap.round,
                                  //   progressColor: Colors.black,
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Container(
                                    width: 300,
                                    color: Colors.grey[100],
                                    child: Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: Titre(
                                          'La note a augmenté au cours des derniers jours.',
                                          15,
                                          Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Titre('Basé sur ${mesVotes.length} votes  ',
                                      15, Colors.black),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.blue,
                            child: Container(
                                color: Colors.black,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Titre(
                                      'Les commentaires', 20, Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: mesVotes.length,
                      itemBuilder: (context, index) {
                        final result = mesVotes[index];
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Titre('Avis', 20, Colors.black),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          for (var i = 0; i < 5; i++)
                                            FaIcon(
                                              i < result['rate']
                                                  ? FontAwesomeIcons.solidStar
                                                  : FontAwesomeIcons.star,
                                              color: i < result['rate']
                                                  ? Colors.amber
                                                  : Colors.black,
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle),
                                      height: 40,
                                      width: 40,
                                      child: Center(
                                          child: Titre('${result['rate']}', 17,
                                              Colors.white)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Titre('COMMENTAIRE', 18, Colors.black),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      NewText(" ${result['commentaire']}", 15,
                                          Colors.black)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          }
        });
  }
}
