import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Page/Admin_Page/screen/HomePageAdmin.dart';

class Actualisation extends StatelessWidget {
  const Actualisation({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home_Admin()));
        },
        icon: Icon(Icons.arrow_back));
  }
}
