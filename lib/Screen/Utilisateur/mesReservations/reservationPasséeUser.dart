import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:gestion_salon_coiffure/Widget/cardMesRservations.dart';
import 'package:gestion_salon_coiffure/Widget/retourEnArriere.dart';
import 'package:gestion_salon_coiffure/Widget/showmodalMesreservations.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class reservatonPasseUser extends StatefulWidget {
  const reservatonPasseUser({super.key});

  @override
  State<reservatonPasseUser> createState() => _reservatonPasseUserState();
}

class _reservatonPasseUserState extends State<reservatonPasseUser> {
  List reservationDejaPasser = [];
  bool isloading = false;
  Future<void> ReservationDejaPasser() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationPasser");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));

    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);
      setState(() {
        reservationDejaPasser = resultat['data'];
        isloading = resultat['status'];
      });
    } else {
      print("${response.statusCode}");
    }

    // print(reservationDejaPasser);
  }

  @override
  void initState() {
    // TODO: implement initState
    ReservationDejaPasser();
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
                await ReservationDejaPasser();
              },
              child: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    reservationDejaPasser.isEmpty
                        ? mesreservations('Aucune réservation passée')
                        : SliverList.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(height: 20);
                            },
                            itemBuilder: (context, index) {
                              final result = reservationDejaPasser[index];
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

                              return carMesresevations(
                                  Days: Days,
                                  chiffre: "${My.day}",
                                  Mounth: Mounth,
                                  libelle: "${result['service']['libelle']}",
                                  heure: "${result['heure']}",
                                  prix: "${result['montant']}",
                                  isEncours: false,
                                  ontap: () {
                                    showmodalMesreservations(
                                        BuildContext,
                                        context,
                                        "${result['service']['photos'][0]['path']}",
                                        result['service']['libelle'],
                                        "$madate",
                                        "${result['heure']}",
                                        "${result['service']['duree']}",
                                        result['montant'],
                                        '${result['id']}',
                                        "Passée");
                                  });
                            },
                            itemCount: reservationDejaPasser.length,
                          ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
