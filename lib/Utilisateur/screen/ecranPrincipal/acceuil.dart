import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestion_salon_coiffure/Utilisateur/screen/ecranPrincipal/compte.dart';
import 'package:gestion_salon_coiffure/Utilisateur/screen/ecranPrincipal/recherche.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:gestion_salon_coiffure/Utilisateur/promotion/promotion_page.dart';
import 'package:gestion_salon_coiffure/Utilisateur/promotion/promotion_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_page.dart';

class acceuil extends StatefulWidget {
  const acceuil({super.key});

  @override
  State<acceuil> createState() => _acceuilState();
}

class _acceuilState extends State<acceuil> {
  List mespromotions = [];
  int nombre = 0;
  Promotion_provider promotionProvider = Promotion_provider();
  Future<void> getPromotion() async {
    promotionProvider.getPromotions().then((value) {
      return setState(() {
        nombre = value;
      });
    });
    print(nombre);
  }

  int _currentindex = 0;

  @override
  void initState() {
    getPromotion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentindex = index;
          });
        },
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        selectedIndex: _currentindex,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.home,
              color: Colors.blue,
            ),
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.search,
              color: Colors.blue,
            ),
            icon: Icon(
              CupertinoIcons.search,
            ),
            label: 'Recherche',
          ),
          InkWell(
            onTap: () {
              print("object");
            },
            child: NavigationDestination(
              selectedIcon: nombre > 0
                  ? badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                      badgeContent: Text("$nombre"),
                      child: InkWell(
                          onTap: () {
                              getPromotion();
                              print("C'est icon");
                          },
                          child: Icon(
                            CupertinoIcons.bell,
                            color: Colors.blue,
                          )),
                    )
                  : InkWell(
                      onTap: () {
                        getPromotion();
                        print("object");
                      },
                      child: Icon(CupertinoIcons.bell,color: Colors.blue,)),
              icon: nombre > 0
                  ? badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                      badgeContent: Text("$nombre"),
                      child: InkWell(
                          onTap: () {
                            getPromotion();
                            print("object");
                          },
                          child: Icon(CupertinoIcons.bell,color: Colors.blue,)),
                    )
                  : InkWell(
                      onTap: () {
                        getPromotion();
                        print("object");
                      },
                      child: Icon(CupertinoIcons.bell,)),
              label: 'Notifications',
            ),
          ),
          NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.person_alt_circle,
              color: Colors.blue,
            ),
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: 'Compte',
          ),
        ],
      ),
      body: _getBody(_currentindex),
    );
  }
}

Widget _getBody(int index) {
  switch (index) {
    case 0:
      return First_page();
    case 1:
      return ExploreScreen();

    case 3:
      return Compte();
    default:
      return Promotion_page();
  }
}

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chats Screen'),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Screen'),
    );
  }
}
