// Splash Screen: Displays app's logo

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ease',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            'It',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            ' .',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff037DD6)),
          )
        ],
      ),
    );
  }
}
