import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class retour extends StatelessWidget {
  const retour({super.key});

  @override
  Widget build(BuildContext context) {
    return   Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.black,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  icon: Icon(
                                                                    CupertinoIcons
                                                                        .arrow_left,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                          );
  }
}