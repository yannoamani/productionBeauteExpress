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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        // color: Colors.red,
                        child: Image.asset(
                          "assets/7113708.jpg",
                          // height: double.infinity,
                          // width: double.infinity,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Titre('Connexion', 30, Colors.black)),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              style: GoogleFonts.andadaPro(
                                color: Color.fromARGB(255, 86, 86, 86),
                                fontSize: 20,
                              ),
                              controller: email,
                              onChanged: (value) => setState(() {
                                _Email = value;
                              }),
                              validator: (value) =>
                                  value!.isEmpty || !regex.hasMatch(value)
                                      ? 'Email non correct'
                                      : null,
                              decoration: InputDecoration(
                                  label: Text(
                                    "Email",
                                    style: GoogleFonts.andadaPro(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 234, 210, 2),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: Icon(CupertinoIcons.envelope)
                                  // prefixIcon: FaIcon(
                                  // CupertinoIcons.envelope,
                                  //   color: Color.fromARGB(255, 86, 86, 86),
                                  // ),
                                  ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextFormField(
                              style: GoogleFonts.andadaPro(
                                color: Color.fromARGB(255, 86, 86, 86),
                                fontSize: 20,
                              ),
                              obscureText: obsuretext,
                              controller: Password,
                              validator: (value) =>
                                  value!.length < 4 || value.isEmpty
                                      ? 'Mot de passe trop court'
                                      : null,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: GoogleFonts.andadaPro(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 86, 86, 86),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 234, 210, 2),
                                          width: 2)),
                                  prefixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obsuretext = !obsuretext;
                                        });
                                      },
                                      icon: Icon(obsuretext == true
                                          ? CupertinoIcons.lock
                                          : CupertinoIcons.lock_open))),
                            ),
                          ],
                        )),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => forgot_password()));
                            },
                            child: Titre('Mot de passe oublié ?', 15,
                                Color.fromARGB(255, 133, 119, 0)))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                charg == false
                                    ? Colors.blue
                                    : Color(0xFF0A345F),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                          onPressed: _Email.isEmpty||charg==true
                              ? null
                              : () {
                                  print("object");
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      charg = true;
                                    });
                                    print("object");
                                    login();
                                  }
                                },
                          child: charg == true
                              ? 
                                 SpinKitCircle(color: Colors.white,)
                              : Mytext('Se connecter', 20, Colors.white)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Mytext("Vous n’avez pas de compte ?", 15, Colors.black),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => inscription()));
                      },
                      child: Titre("Inscrivez-vous ici !", 15,
                          Color.fromARGB(255, 133, 119, 0)),
                    ),

                    // Row(
                    //   children: [
                    //     Mytext(" Vous n’avez pas de compte ?", 15, Colors.black),

                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    SizedBox(height: 40),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Beauté Express © ${DateTime.now().year}",
                          style: const TextStyle(
                              color: Color(0xFF0A345F),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        )),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       height: 50,
                    //       width: 60,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           border: Border.all(color: Colors.grey)),
                    //       child: Center(child: FaIcon(FontAwesomeIcons.google)),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       height: 50,
                    //       width: 60,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           border: Border.all(color: Colors.grey)),
                    //       child: Center(child: FaIcon(FontAwesomeIcons.facebook)),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       height: 50,
                    //       width: 60,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //           )),
                    //       child: Center(child: FaIcon(FontAwesomeIcons.apple)),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
