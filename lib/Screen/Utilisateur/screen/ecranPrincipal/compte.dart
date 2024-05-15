import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/reservationAdmin/MesNotes.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/mesReservations/mes_reservation.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/Login_page/Update_users.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/Login_page/login_page.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/coupons/AllCoupons.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/promotion/promotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Compte extends StatefulWidget {
  const Compte({super.key});

  @override
  State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  String nom = '';
  String prenom = '';
  String email = '';
  String number = "";
  String token = "";
  int? IdRole = 0;
  int rating = 0;
  textStyleUtils cutomStyle = textStyleUtils();
  TextEditingController _controlCommentaire = TextEditingController();

  Future yanno() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nom = prefs.get('name').toString();
      prenom = prefs.get('prenom').toString();
      email = prefs.get('email').toString();
      number = prefs.get('phone').toString();
      token = prefs.get('token').toString();
      IdRole = prefs.getInt('id_role');
    });

    print(number);
    print(prenom);
    print(IdRole);
  }

  Future Logout() async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl('logout');
    var uri = Uri.parse(url);
    var response =
        await http.post(uri, headers: header('${prefs.getString("token")}'));
    if (response.statusCode == 200) {
      message(context, "Deconnecter avec succès", Colors.green);
      prefs.remove('token');
      prefs.remove('name');
      prefs.remove('prenom');
      prefs.remove('phone');
      prefs.remove('email');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login_page()),
        (route) => false,
      );
    } else {
      message(context, "Erreur  rencontré", Colors.red);
    }
    print(response.body);
  }

  List Reservation_A_V = [];

  Future<void> ReservationAvenir() async {
    final prefs = await SharedPreferences.getInstance();
    final url = monurl("reservationOdui");
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: header('${prefs.getString('token')}'));
    if (response.statusCode == 200) {
      final resultat = jsonDecode(response.body);
      setState(() {
        Reservation_A_V = resultat['data'];
      });
    } else {
      message(context, "${response.statusCode}", Colors.red);
    }
    // print(Reservation_A_V);
  }

  List service = [];
  Future<void> GetService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = monurl('services');
      final uri = Uri.parse(url);
      final response =
          await http.get(uri, headers: header('${prefs.get('token')}'));

      if (response.statusCode == 200) {
        final resultat = jsonDecode(response.body);
        setState(() {
          service = resultat['data'];
        });

        print(response.body);
      } else {
        print(
            "Erreur lors de la récupération des données. Code d'état : ${response.body}");
      }
    } catch (error) {
      print("Erreur lors de la récupération des données : $error");
    }
  }

  Future<void> Noter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var Url = monurl('notes');
      final uri = Uri.parse(Url);
      final response = await http.post(uri,
          body: jsonEncode({
            'service_id': recup,
            'rate': rating,
            'user_id': prefs.get('id'),
            'commentaire': _controlCommentaire.text
          }),
          headers: header("${prefs.get('token')}"));
      final result = jsonDecode(response.body);

      if (result['status'] == 'true') {
        message(context, 'Note envoyé avec succès ', Colors.green);
        rating = 0;
        Future.delayed(Duration(milliseconds: 1000));
        {
          Navigator.of(context).pop();
        }
        _controlCommentaire.clear();
      } else {
        message(context, "${result['mesage']}", Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  int? recup;
  List mesCoupons = [];
  Promotion_provider getAllCoupons = Promotion_provider();
  Future<void> getCoupons() async {
    getAllCoupons.getCouponsActif().then((value) => setState(() {
          mesCoupons = value;
        }));
  }

  @override
  void initState() {
    yanno();
    ReservationAvenir();

    getCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue,
        // appBar: AppBar(
        //   title: Titre("Mon espace", 24, Colors.black),
        //   centerTitle: true,
        //   // backgroundColor: Colors.blue,
        //   automaticallyImplyLeading: false,
        // ),
        body: FutureBuilder(
            future: Future.delayed(Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (IdRole == 0) {
                return Scaffold(
                    body: Center(
                        child: CupertinoActivityIndicator(
                  radius: 20,
                )));
              } else {
                return Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () async {
                      yanno();
                      getCoupons();
                      ReservationAvenir();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Scrollbar(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/pngwing.com.png",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit
                                            .cover, // Pour que l'image s'adapte à l'intérieur du cercle
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$nom",
                                  style:
                                      cutomStyle.titreStyle(Colors.black, 18),
                                ),
                                Text(
                                  "$email",
                                  style:
                                      cutomStyle.curenttext(Colors.black, 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(CupertinoIcons.lock),
                                  title: Text(
                                    "Changer mes accès",
                                    style:
                                        cutomStyle.curenttext(Colors.black, 18),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => details()));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => details()));
                                  },
                                  trailing:
                                      Icon(CupertinoIcons.arrow_right_square),
                                ),
                                if (IdRole == 2)
                                  ListTile(
                                    leading: Reservation_A_V.length == 0
                                        ? Icon(CupertinoIcons.calendar)
                                        : Badge(
                                            label: Text(
                                                "${Reservation_A_V.length}"),
                                            child:
                                                Icon(CupertinoIcons.calendar),
                                          ),
                                    title: Text(
                                      "Mes réservations",
                                      style: cutomStyle.curenttext(
                                          Colors.black, 18),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  Mes_reservations()));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             Mes_reservations()));
                                    },
                                    trailing:
                                        Icon(CupertinoIcons.arrow_right_square),
                                  ),
                                if (IdRole == 2)
                                  ListTile(
                                    leading: mesCoupons.length == 0
                                        ? Icon(CupertinoIcons.ticket)
                                        : Badge(
                                            label: Text("${mesCoupons.length}"),
                                            child: Icon(CupertinoIcons.ticket),
                                          ),
                                    title: Text(
                                      "Mes Coupons",
                                      style: cutomStyle.curenttext(
                                          Colors.black, 18),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  allCOupons()));
                                    },
                                    trailing:
                                        Icon(CupertinoIcons.arrow_right_square),
                                  ),
                                if (IdRole == 3)
                                  ListTile(
                                    leading: Icon(CupertinoIcons.star),
                                    title: Text(
                                      "Mes notes",
                                      style: cutomStyle.curenttext(
                                          Colors.black, 18),
                                    ),
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => MesNotes()));
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  MesNotes()));
                                    },
                                    trailing:
                                        Icon(CupertinoIcons.arrow_right_square),
                                  ),
                                //  if (IdRole == 2)

                                Divider(),
                                ListTile(
                                  leading:
                                      FaIcon(CupertinoIcons.question_circle),
                                  title: Text(
                                    "Help & Support",
                                    style:
                                        cutomStyle.curenttext(Colors.black, 18),
                                  ),
                                  trailing:
                                      FaIcon(CupertinoIcons.arrow_right_square),
                                ),
                                ListTile(
                                  onTap: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text(
                                            "Deconnexion",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18),
                                          ),
                                          content: const Text(
                                            "Souhaitez-vous vous déconnecter maintenant ?",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                ReservationAvenir();
                                              },
                                              child: Text("Non"),
                                            ),
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: TextButton(
                                                  onPressed: () async {
                                                    Logout();
                                                  },
                                                  child: Text("Oui")),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: FaIcon(CupertinoIcons.power),
                                  title: Text(
                                    "Deconnexion",
                                    style:
                                        cutomStyle.curenttext(Colors.black, 18),
                                  ),
                                  trailing:
                                      FaIcon(CupertinoIcons.arrow_right_square),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(Compte());
}
