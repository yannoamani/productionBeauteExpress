import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_salon_coiffure/Utils/utils.dart';

class cardCoupons extends StatelessWidget {
  final String status;
  final String code;
  final String pourcentage;

  final String expiration;
  const cardCoupons(
      {required this.status,
      required this.code,
      required this.expiration,
      required this.pourcentage});

  @override
  Widget build(BuildContext context) {
    textStyleUtils textstyle = textStyleUtils();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipPath(
        clipper: TicketClipper(),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: status == "Utilisé"
                  ? Colors.red[100]
                  : status == "Expiré"
                      ? Colors.red[100]
                      : Colors
                          .green[100], // Fond jaune clair // Fond jaune clair
              borderRadius: BorderRadius.circular(12.0),

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Coupon N*${code}",
                        style: textstyle.titreStyle(Colors.black, 20)),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: status == "Utilisé"
                            ? Colors.red
                            : status == "Expiré"
                                ? Colors.red
                                : Colors.green,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '${status}',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text('Expiration : $expiration',
                    style: textstyle.curenttext(Colors.black, 17)),
                SizedBox(height: 12.0),
                Text('Pourcentage : ${pourcentage}%',
                    style: textstyle.curenttext(Colors.black, 17)),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: 15));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 15));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
