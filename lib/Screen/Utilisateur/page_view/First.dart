import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/Login_page/login_page.dart';
import 'package:gestion_salon_coiffure/Widget/sizeboxtype.dart';
import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:gestion_salon_coiffure/Widget/boutton.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';

class MaPremiere extends StatefulWidget {
  const MaPremiere({super.key});

  @override
  State<MaPremiere> createState() => _MaPremiereState();
}

class _MaPremiereState extends State<MaPremiere> {
  textStyleUtils buttonstyle = textStyleUtils();

  @override
  @override
  Widget build(BuildContext context) {
    SizeConfig().mySize(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pexels-nothing-ahead-3230236.jpg'),
            fit: BoxFit.cover, // specify the fit property if needed
          ),
        ),
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
                    0.2,
                    1.0
                  ]),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateTextSize(8)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Alignement horizontal au centre
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(
                                  "Bienvenue dans l'univers du massage",
                                  textAlign: TextAlign.center,
                                  style: textStyleUtils()
                                      .curenttext(Colors.white, 18)
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Mytext(
                                "Explorez notre havre de paix où chaque instant est dédié à votre sérénité, et laissez nos mains expertes vous guider vers une évasion totale du stress ",
                                15,
                                Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    mysizeboxheight(20),
                    bouttonCustom(
                        titre: "Commencer",
                        couleur: Color(0xFFAE8F29),
                        tap: () {
                          Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                  builder: (context) => Login_page()));
                        }),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                  ]),
            )),
      )),
    );
  }
}
