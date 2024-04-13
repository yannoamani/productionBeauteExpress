import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final double taille;
  final VoidCallback? onTap; // Ajoutez cette ligne

  const CustomListTile({
    required this.title,
    required this.taille,
   required this.onTap, // Ajoutez cette ligne
  });

  @override
  Widget build(BuildContext context) {
    textStyleUtils textstyle = textStyleUtils();
    return ListTile(
      title: Text(
        "$title",
        style: textstyle.soustitre(Colors.black, taille),
      ),
      onTap: onTap, 
    );
  }
}
