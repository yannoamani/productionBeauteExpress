import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/style/utils.dart';

class chargementPage extends StatelessWidget {
  final String titre;
  final bool arrowback;
  const chargementPage({required this.titre, required this.arrowback});

  @override
  Widget build(BuildContext context) {
    textStyleUtils textstyle = textStyleUtils();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: arrowback,
        title: Text("$titre",
        
        style:textstyle.curenttext(Colors.black, 20) ,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: Colors.black,
              radius: 35,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Chargement ...",
              style:textstyle.curenttext(Colors.black, 20) ,
            ),
          ],
        ),
      ),
    );
  }
}
