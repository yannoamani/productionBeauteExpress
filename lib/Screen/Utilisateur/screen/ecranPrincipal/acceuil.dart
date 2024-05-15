import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/screen/ecranPrincipal/compte.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/screen/ecranPrincipal/recherche.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gestion_salon_coiffure/Screen/Utilisateur/promotion/promotion_page.dart';
import 'package:gestion_salon_coiffure/Screen/Utilisateur/promotion/promotion_provider.dart';

import 'first_page.dart';

class acceuil extends StatefulWidget {
  const acceuil({super.key});

  @override
  State<acceuil> createState() => _acceuilState();
}

class _acceuilState extends State<acceuil> {
  Color jauneMoutarde = Color(0xFFAE8F29);
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
          if (_currentindex == 2) {
            nombre = 0;
          }
        },
        indicatorColor: Colors.grey[100],
        surfaceTintColor: Colors.transparent,
        selectedIndex: _currentindex,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.home,
              color: jauneMoutarde,
            ),
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.search,
              color: jauneMoutarde,
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
              selectedIcon: Icon(
                CupertinoIcons.bell,
                color: jauneMoutarde,
              ),
              icon: nombre > 0
                  ? badges.Badge(
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                      badgeContent:
                          Text("${_currentindex == 2 ? nombre = 0 : nombre}"),
                      child: InkWell(
                          onTap: () {
                            getPromotion();
                            print("object");
                          },
                          child: Icon(
                            CupertinoIcons.bell,
                            // color: Colors.blue,
                          )),
                    )
                  : Icon(
                      CupertinoIcons.bell,
                    ),
              label: 'Notifications',
            ),
          ),
          NavigationDestination(
            selectedIcon: Icon(
              CupertinoIcons.person_alt_circle,
              color: jauneMoutarde,
            ),
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: 'Compte ',
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
      return const First_page();

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
