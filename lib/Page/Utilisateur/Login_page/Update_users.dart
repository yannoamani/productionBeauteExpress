import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class details extends StatefulWidget {
  const details({super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  bool charg = false;
  bool charg1 = false;

  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emailPassword = TextEditingController();
  TextEditingController Ancienpassword = TextEditingController();
  TextEditingController Newpassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  var mynom;
  textStyleUtils customStyle = textStyleUtils();
  Future getinfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mynom = prefs.getInt('id');
      nom.text = prefs.getString('name').toString();
      prenom.text = prefs.getString('prenom').toString();
      email.text = prefs.getString('email').toString();
      emailPassword.text = prefs.getString('email').toString();
      phone.text = prefs.getString('phone').toString();
    });
  }

  Future<void> update() async {
    final url = monurl("users/$mynom");
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode({
          "nom": nom.text,
          "prenom": prenom.text,
          "email": email.text,
          'phone': phone.text,
          'password': password.text
        }),
        headers: header(''));
    print(response.body);
    final decode = jsonDecode(response.body);
    if (decode['status']) {
      message(context, 'Modifier avec succès', Colors.green);
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString('name', decode['user']['nom']);
        prefs.setString('prenom', decode['user']['prenom']);
        prefs.setString('email', decode['user']['email']);
      });
      email.clear();
      nom.clear();
      prenom.clear();
      phone.clear();
      setState(() {
        charg = true;
        Navigator.pop(context);
      });
    }
  }

  Future<void> Modifier_Password() async {
    final prefs = await SharedPreferences.getInstance();
    var url = monurl("modifyPassword");
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(
          {
            'email': emailPassword.text,
            'oldPassword': Ancienpassword.text,
            'password': Newpassword.text
          },
        ),
        headers: header(prefs.getString('token')!));
    print(response.body);
    final result = jsonDecode(response.body);
    if (result['status']) {
      setState(() {
        charg1 = false;
      });
      message(context, result['message'], Colors.green);
      Navigator.pop(context);
    } else {
      message(context, "${result['message']} ressayer", Colors.red);
      setState(() {
        charg1 = false;
      });
    }
    email.clear();
    Ancienpassword.clear();
    Newpassword.clear();
  }

  @override
  void initState() {
    getinfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
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
                  height: 25,
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: NewText("Mon profil", 30, Colors.black)),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    VraiInput(nom, "Nom", CupertinoIcons.person),
                    const SizedBox(
                      height: 30,
                    ),
                    VraiInput(prenom, "Prenom", CupertinoIcons.person),
                    const SizedBox(
                      height: 30,
                    ),
                    VraiInput(email, "Email", CupertinoIcons.envelope),
                    const SizedBox(
                      height: 30,
                    ),
                    VraiInput(phone, 'Phone', CupertinoIcons.phone),
                    const SizedBox(
                      height: 30,
                    ),
                    boutton(context, charg, customStyle.getPrimaryColor(),
                        "MODIFIER", () {
                      setState(() {
                        charg = true;
                      });
                      getinfo();
                      update();
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "MODIFIER LE MOT DE PASSE",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.andadaPro(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    VraiInput(emailPassword, 'Email', CupertinoIcons.envelope),
                    SizedBox(
                      height: 20,
                    ),
                    VraiInput(Ancienpassword, "Ancien mot de passe",
                        CupertinoIcons.lock),
                    SizedBox(
                      height: 20,
                    ),
                    VraiInput(Newpassword, "Nouveau Mot de passe",
                        CupertinoIcons.lock),
                    SizedBox(
                      height: 25,
                    ),
                    boutton(context, charg1, customStyle.getPrimaryColor(), " Modifier ", () {
                      setState(() {
                        charg1 = true;
                      });
                      Modifier_Password();
                    })
                  ],
                )),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ));
  }
}
