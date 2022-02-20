import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(0xff037DD6),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Please wait a moment',
          style: TextStyle(color: Colors.grey[600]),
        )
      ],
    ));
  }
}
