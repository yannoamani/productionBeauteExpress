import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class popupButton extends StatelessWidget {
   final List<PopupMenuEntry<String>> items;
  // final Function(String) onSelected;
 popupButton({required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => items,
    
    );
  }
}