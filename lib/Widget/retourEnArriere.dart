import 'package:flutter/cupertino.dart';

class circleChargemnt extends StatelessWidget {
  const circleChargemnt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 25,
      ),
    );
  }
}
