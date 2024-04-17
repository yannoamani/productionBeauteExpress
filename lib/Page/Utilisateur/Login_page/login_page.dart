import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/screen/HomePageAdmin.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/screen/ecranPrincipal/acceuil.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/Login_page/forgot_password.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/Login_page/inscription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key, this.label});
  final String? label;

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  // bool _obscure = true;
  bool charg = false;
  TextEditingController email = TextEditingController();
  TextEditingController Password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  String _Email = '';
  bool obsuretext = false;
  Color jauneMoutarde = Color(0xFFAE8F29);

  // Custome _custome = Custome();
  // Rx<User> users = User("", "").obs;
  // TesterUser LOgin = TesterUser('', '', true as Bool);
  // LoginProvider loginProvider = LoginProvider();

  Future<void> login() async {
    try {
      final Vemail = email.text;
      final Vpassword = Password.text;
      var url = monurl("login");
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode({"email": Vemail, "password": Vpassword}),
          headers: header(""));
      final decode = jsonDecode(response.body);
      // print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          charg = false;
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('name', '${decode['data']['nom']}');
        prefs.setString('prenom', '${decode['data']['prenom']}');
        prefs.setString('token', '${decode['access_token']}');
        prefs.setInt('id', decode['data']['id']);
        prefs.setString('phone', '${decode['data']['phone']}');
        prefs.setString('email', '${decode['data']['email']}');
        prefs.setInt('id_role', decode['data']['role']['id']);

        print("Je suis" + prefs.getString('token')!);
        print("Je suis" + prefs.getString('name')!);
        print(prefs.getInt('id'));
        print("Je suis" + prefs.getString('phone')!);

        print('${decode['data']['role']['id']}');
        if (decode['data']['role']['id'] == 2) {
          prefs.setInt('id_role', decode['data']['role']['id']);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const acceuil()));
        } else if (decode['data']['role']['id'] == 3) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home_Admin()));
        } else {
          message(context, "Vous n'êtes pas autorisé", Colors.red);
        }

        message(context, 'Connecter avec succès', Colors.green);
      } else {
        setState(() {
          charg = false;
        });
        message(context, '${decode['message']}', Colors.red);
      }
    } catch (e) {
      setState(() {
        charg = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/nouveau.png",
                        ),
                        fit: BoxFit.fill)),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent, // Noir transparent (en haut)
                          Colors.black, // Noir complet (en bas)
                        ],
                        stops: [
                          0.1,
                          0.6
                        ]),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Titre("Bienvenue", 30, Colors.white),
                      Expanded(
                          child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Titre("Bienvenue ", 30, Colors.white),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Mytext("Connecte toi à ton compte", 15,
                                      Colors.white),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Form(
                                      key: formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextFormField(
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: email,
                                            onChanged: (value) => setState(() {
                                              _Email = value;
                                            }),
                                            validator: (value) =>
                                                value!.isEmpty ||
                                                        !regex.hasMatch(value)
                                                    ? 'Email non correct'
                                                    : null,
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                label: Text(
                                                  "Email",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 20,
                                                      color: Colors.grey[100]),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                jauneMoutarde,
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                prefixIcon: const Icon(
                                                  CupertinoIcons.envelope,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          TextFormField(
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            obscureText: obsuretext,
                                            controller: Password,
                                            validator: (value) =>
                                                value!.length < 4 ||
                                                        value.isEmpty
                                                    ? 'Mot de passe trop court'
                                                    : null,
                                            decoration: InputDecoration(
                                                labelText: "Password",
                                                labelStyle: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            BorderSide(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                width: 2)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                            color: Colors.white,
                                                            width: 2)),
                                                prefixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        obsuretext =
                                                            !obsuretext;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      obsuretext == true
                                                          ? CupertinoIcons.lock
                                                          : CupertinoIcons
                                                              .lock_open,
                                                      color: Colors.white,
                                                    ))),
                                          ),
                                          SizedBox(
                                            height: 1,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            forgot_password()));
                                              },
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Titre(
                                                      'Mot de passe oublié ?',
                                                      15,
                                                      jauneMoutarde))),
                                          Container(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      charg == false
                                                          ? jauneMoutarde
                                                          : Color(0xFF0A345F),
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    )),
                                                onPressed: _Email.isEmpty ||
                                                        charg == true
                                                    ? null
                                                    : () {
                                                        print("object");
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            charg = true;
                                                          });
                                                          print("object");
                                                          login();
                                                        }
                                                      },
                                                child: charg == true
                                                    ? SpinKitCircle(
                                                        color: Colors.white,
                                                      )
                                                    : Mytext('Se connecter', 20,
                                                        Colors.white)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Mytext("Vous n’avez pas de compte ?",
                                              15, Colors.white),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          inscription()));
                                            },
                                            child: Titre("Inscrivez-vous ici !",
                                                17, jauneMoutarde),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
