import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Page/Utilisateur/Login_page/ConfirmReset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  bool test = false;
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final GlobalKey<FormState> _MyKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  textStyleUtils textstyle = textStyleUtils();
  bool char = false;
  Future<void> resetPassword() async {
    try {
      final url = monurl("password");
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: header('Token'),
        body: jsonEncode(
          {'email': email.text},
        ),
      );
      final result = jsonDecode(response.body);
      print(response.body);
      if (result['status']) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ConfrimReset()),
        );
      } else {
        message(context, "${result['message']}", Colors.red);
        setState(() {
          char = false;
        });
      }
    } catch (e) {
      print("$e");
      setState(() {
        char = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color jauneMoutarde = Color(0xFFAE8F29);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Icône pour le bouton de retour
            color: Colors.white, // Couleur de l'icône
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   // height: 100,
                  //   // width: 100,
                  //   child: Image.asset(
                  //     "assets/oublie.jpg",
                  //     height: 200,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Align(
                        alignment: Alignment.center,
                        child:
                            Titre("Mot de passe oublié ?", 30, Colors.white)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Veuillez entrer votre adresse e-mail ci-dessous et cliquer sur le bouton 'Renitialiser' pour recevoir votre nouveau mot de passe.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 15),
                        )),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: _MyKey,
                    child: TextFormField(
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      controller: email,
                      validator: (value) =>
                          value!.isEmpty || !regex.hasMatch(value)
                              ? 'Email non correct'
                              : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Email ID',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: textstyle.primarybutton(jauneMoutarde),
                        onPressed: () {
                          if (_MyKey.currentState!.validate()) {
                            resetPassword();

                            setState(() {
                              char = true;
                            });
                          }
                        },
                        child: char == true
                            ? SpinKitCircle(
                                color: Colors.white,
                              )
                            : Mytext("Renitialiser", 20, Colors.white)),
                  ),
                  // Text("$char")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
