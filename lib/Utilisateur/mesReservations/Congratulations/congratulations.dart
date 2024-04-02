import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utilisateur/mesReservations/mes_reservation.dart';
import 'package:gestion_salon_coiffure/Utilisateur/screen/ecranPrincipal/acceuil.dart';
import 'package:gestion_salon_coiffure/Utilisateur/screen/ecranPrincipal/first_page.dart';
import 'package:gestion_salon_coiffure/Utilisateur/module_reservation/reservation_provider.dart';

class Congratulation extends StatefulWidget {
  const Congratulation({super.key});

  @override
  State<Congratulation> createState() => _CongratulationState();
}

class _CongratulationState extends State<Congratulation> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const acceuil()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/6ob.gif',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Rendez-vous valider",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Icon(
                      Icons.done_outline,
                      size: 100,
                      color: Colors.green,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
