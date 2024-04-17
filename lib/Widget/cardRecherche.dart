import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/fonction/fonction.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class cardRecherche extends StatelessWidget {
  final CarouselController carousel;
  final List photos;
  final String libelle;
  final String prix;
  final String description;
  final Callback onTap;

  const cardRecherche({required this.carousel,required this.photos,required this.libelle,required this.prix,required this.description,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                  spreadRadius: 5, // Étendue de l'ombre
                  blurRadius: 7, // Flou de l'ombre
                  offset: Offset(0, 3), // Décalage de l'ombre
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InkWell(
                    child: Container(
                      child: CarouselSlider(
                        carouselController: carousel,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          height: 300.0,
                        ),
                        items: photos.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              String imagePath = ImgDB("${i['path']}");
                              return GestureDetector(
                                // onTap: () {},
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Image.network(
                                            i['path'] == null
                                                ? 'https://via.placeholder.com/200'
                                                : imagePath,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                Container(
                    // color: Colors.blue,
                    // width: 200,
                    child: Text(
                      "${libelle}",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                Container(
                  child: Text(
                    '${prix} FCFA',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${description}",
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFAE8F29)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                    onPressed:onTap,
                    child: NewText("Voir plus",15,Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
