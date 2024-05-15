import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';

import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/Login_page/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class inscription extends StatefulWidget {
  const inscription({super.key});

  @override
  State<inscription> createState() => _inscriptionState();
}

class _inscriptionState extends State<inscription> {
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController VerifPassword = TextEditingController();
  TextEditingController number = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool charg = false;
  var test = '';
  final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  textStyleUtils textstyle = textStyleUtils();

  Future<void> add_users() async {
    var url = monurl('users');
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: jsonEncode(
            {
              'nom': nom.text,
              'prenom': prenom.text,
              'email': email.text,
              'password': Password.text,
              'phone': number.text,
              'role_id': 2
            },
          ),
          headers: header(''));
      print(response.body);
      final result = jsonDecode(response.body);
      if (result['status']) {
        setState(() {
          charg = false;
        });
        message(context, 'Inscription reussie', Colors.blue);
        email.clear();
        nom.clear();
        prenom.clear();
        Password.clear();
        number.clear();
        Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const Login_page())));
      } else {
        message(context, "${result['message']}", Colors.red);
        setState(() {
          charg = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Color jauneMoutarde = Color(0xFFAE8F29);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 30),
                //   child: Container(
                //     height: 250,
                //     width: double.infinity,
                //     // color: Colors.red,
                //     child: Image.asset(
                //       "assets/7113708.jpg",
                //       // height: double.infinity,
                //       // width: double.infinity,
                //       // fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Align(
                    alignment: Alignment.center,
                    child: Titre('Inscription', 30, Colors.white)),
                SizedBox(
                  height: 15,
                ),
                NewText(
                    "Inscrivez-vous pour réserver votre prochain moment de détente.",
                    15,
                    Colors.white),
                SizedBox(
                  height: 15,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: nom,
                          validator: (value) => value!.isEmpty
                              ? 'Renseignez correctement ce champs'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Nom',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: jauneMoutarde, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                              )),
                        ),
                        // champs("Nom", nom, Icons.person),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: prenom,
                          validator: (value) => value!.isEmpty
                              ? 'Renseignez correctement ce champs'
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Prenom',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 234, 210, 2),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: number,
                          maxLength: 10,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          validator: (value) =>
                              value!.isEmpty || value.length < 10
                                  ? 'Contact non correct'
                                  : null,
                          decoration: InputDecoration(
                              hintText: 'Contact',
                              hintStyle: GoogleFonts.andadaPro(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: const Icon(
                                CupertinoIcons.phone,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.isEmpty || !regex.hasMatch(value)
                                  ? 'Email non correct'
                                  : null,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Email@gmail.com',
                              hintStyle: GoogleFonts.andadaPro(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(
                                          255, 234, 210, 2),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                CupertinoIcons.envelope,
                                color: Colors.white,
                              )),
                        ),
                        // phone("Numero de téléphone", number, Icons.numbers),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: VerifPassword,
                          onChanged: (value) => setState(() {
                            test = value;
                          }),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.isEmpty || value.length < 4
                                  ? 'Mot de passe trop court'
                                  : null,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Mot de passe',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: jauneMoutarde, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                CupertinoIcons.lock,
                                color: Colors.white,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          controller: Password,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.isEmpty ||
                                  value != test ||
                                  value.length < 4
                              ? 'Mot de passe non conforme'
                              : null,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Confirmation du mot de passe",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: jauneMoutarde, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                CupertinoIcons.lock,
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: textstyle.primarybutton(jauneMoutarde),
                              onPressed: charg == true
                                  ? null
                                  : () {
                                      print("object");
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          charg = true;
                                        });
                                        add_users();
                                      }
                                    },
                              child: charg == true
                                  ? SpinKitCircle(
                                      color: Colors.white,
                                    )
                                  : Mytext("S'inscrire", 20, Colors.white)),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Mytext("Déjà membre ? ", 15, Colors.white),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Login_page()));
                  },
                  child: Titre("Connectez-vous ici !", 17, jauneMoutarde),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
