import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gestion_salon_coiffure/Screen/Admin_Page/screen/HomePageAdmin.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/screen/ecranPrincipal/acceuil.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/page_view/PageVewFirst.dart';
import 'package:gestion_salon_coiffure/style/Sizeconfig.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      final pefs = await SharedPreferences.getInstance();
      if (pefs.getString('token') != null) {
        if (pefs.getInt('id_role') == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const acceuil()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home_Admin()));
        }
        //    Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           const acceuil()),
        // );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  TabView()), // Assuming Connexion is a widget
        );
      }
    });
  }

  Widget build(BuildContext context) {
    SizeConfig().mySize(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Beauté express',
                style: textStyleUtils().curenttext(Colors.white, 30),
              ),
              SizedBox(
                height: 30,
              ),
              SpinKitFadingCircle(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
