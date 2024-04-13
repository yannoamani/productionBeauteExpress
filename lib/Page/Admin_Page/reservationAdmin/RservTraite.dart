import 'dart:convert';

import 'package:circular_badge_avatar/circular_badge_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/mesReservations/mes_reservation.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationTraite extends StatefulWidget {
  const ReservationTraite({super.key});

  @override
  State<ReservationTraite> createState() => _ReservationTraiteState();
}

class _ReservationTraiteState extends State<ReservationTraite> {
  List MesReservations = [];
  bool isLoading = false;
// ignore: non_constant_identifier_names
  Future<void> GetReservation() async {
    final prefs = await SharedPreferences.getInstance();

    var url = monurl('reservationAdminValide');
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    print(response.body);
    final resultat = jsonDecode(response.body);
    setState(() {
      MesReservations = resultat['data'];
      isLoading = resultat['status'];
    });
    print(MesReservations);
  }

  @override
  void initState() {
    // TODO: implement initState
    GetReservation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (isLoading == false) {
            return  Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "En cours de chargement ...",
                      style: TextStyle(fontSize: 20,
                      
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CupertinoActivityIndicator(radius: 20),
                  ],
                ),
              ),
            );
          }
          else{
             return  Scaffold(
              body: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      // backgroundColor: Colors.blue,
                      centerTitle: true,
                      title: Titre(
                          'Reservatioins Traités ', 15, Colors.black),
                    ),
                 const   SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Titre('Reservation à venir', 25, Colors.black),
                        ],
                      ),
                    ),
                 MesReservations.isEmpty
                        ? mesreservations("Aucune réservation terminée")
                        :    SliverList.separated(
                        itemCount: MesReservations.length,
                        itemBuilder: (context, index) {
                          final resultats = MesReservations[index];
                          final nom = resultats['user']['nom'];
                          final prenom = resultats['user']['prenom'];
                          final email = resultats['user']['email'];
                          final phone = resultats['user']['phone'];
                          String date = resultats['date'];
                          String heure = resultats['heure'];
                          final heure_deb = resultats['date_debut'];
                          final heure_fin = resultats['date_fin'];
                          // final date = "2024-02-01";
                          // final heure = "13:00";
                          // final nom = "Anon";
                          // final prenom = "Amani Beda Yann ";
                          final status = resultats['status'];
                          DateTime Convert = DateTime.parse(date);
                          String NewDate =
                              DateFormat.yMMMEd('fr_FR').format(Convert);
                          return ListTile(
                            title: NewText('$nom $prenom', 15, Colors.black),
                            subtitle:
                                NewText('$heure_deb à $heure_fin', 12,Colors.green),
                            trailing: const  FaIcon(FontAwesomeIcons.circleCheck,color: Colors.green,),
                            leading: const  CircularBadgeAvatar(
                                  iconPosition: 30,
                                
                
                                  icon: FontAwesomeIcons.check,
                                  iconColor: Colors.green,
                
                                  // centeralText: "Mukta Ahmed",
                
                                  /// [if you want to use asset image]
                                  // assetImage: "assets/images/asset_image.png",
                                ),
                            onTap: () {
                              showModalBottomSheet(
                                  //  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  // isDismissible: true,
                                  elevation: 8,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(),
                                      body: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 150,
                                                  // width: dou,
                                                  child: Center(
                                                    child: CircularBadgeAvatar(
                                                          iconPosition: 100,
                                                    
                                                          icon: FontAwesomeIcons
                                                              .check,
                                                          iconColor: Colors.green,
                                                    
                                                          // centeralText: "Mukta Ahmed",
                                                    
                                                          /// [if you want to use asset image]
                                                          // assetImage: "assets/images/asset_image.png",
                                                        ),
                                                  ),
                                                ),
                                                
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  child: Column(
                                                    children: [
                                                 
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Center(
                                                        child: Titre(
                                                            'Informations sur le client',
                                                            20,
                                                            Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      ListTile(
                                                        leading: circlevalidate(
                                                            FontAwesomeIcons
                                                                .user),
                                                        title: NewText('$nom', 15,
                                                            Colors.black),
                                                        subtitle: NewText(
                                                            '$prenom',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      ListTile(
                                                        leading: circlevalidate(
                                                            FontAwesomeIcons
                                                                .envelope),
                                                        title: NewText('$email',
                                                            15, Colors.black),
                                                      ),
                                                      Divider(),
                                                     
                                                      // ListTile(
                                                      //   leading: circlevalidate(
                                                      //       CupertinoIcons.check_mark_circled
                                                      //           ),
                                                      //   title: NewText('$heure_deb -$heure_fin',
                                                      //       15, Colors.black),
                                                          
                                                      // ),
                                                
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                          child: Titre(
                                                              'Informations sur la reservaton',
                                                              20,
                                                              Colors.black)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      ListTile(
                                                        leading: circlevalidate(
                                                            FontAwesomeIcons
                                                                .briefcase),
                                                        title: NewText(
                                                            '${resultats['service']['libelle']}',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                       ListTile(
                                                            leading: circlevalidate(
                                                                FontAwesomeIcons
                                                                    .calendarWeek),
                                                            title: NewText(
                                                                '$NewDate',
                                                                15,
                                                                Colors.black),
                                                          ),
                                                          Divider(),
                                                      ListTile(
                                                        leading: circlevalidate(
                                                            FontAwesomeIcons
                                                                .clock),
                                                        title: NewText(
                                                            '$heure',
                                                            15,
                                                            Colors.black),
                                                      ),
                                                      Divider(),
                                                      ListTile(
                                                        leading: circlevalidate(
                                                            FontAwesomeIcons
                                                                .hourglass),
                                                        title: 
                                                       Text.rich(
                                                          TextSpan(
                                                            text: 'De ',
                                                            children: [
                                                              TextSpan(
                                                                text: "${resultats['date_debut']}",
                                                                style: TextStyle(fontWeight: FontWeight.bold)
                                                              ),
                                                              TextSpan(
                                                                text: " à",

                                                              ),
                                                                TextSpan(
                                                                  text: " ${resultats['date_fin']}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)
                                                                )]
                                                      
                                                  
                                                      ),
                                                   
                                                       )),
                                                      Divider(),
                                                     
                                                     
                                                      
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          NewBold("Coût :", 15,
                                                              Colors.black),
                                                          NewBold("${resultats['montant']} FCFA", 18,
                                                              Colors.red)
                                                        ],
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            
                          );
                        },
                        separatorBuilder: (context, index) => Divider())
                  ],
                ),
              ),
            );
          }
        });
  }
}

class MyCustomClipper extends CustomClipper<Path> {
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
