// To display toast notifications in the app

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// get color of toast based on type
Color getColor(String type) {
  if (type == "error") {
    return Color(0xffbb121a);
  } else if (type == "success") {
    return Color(0xff107154);
  } else {
    return Color(0xff095aba);
  }
}

// get icon for toast based on type
Icon getIcon(String type) {
  if (type == "error") {
    return Icon(
      Icons.cancel_outlined,
      color: Colors.white,
    );
  } else if (type == "success") {
    return Icon(
      Icons.check_circle_outline,
      color: Colors.white,
    );
  } else {
    return Icon(
      Icons.info_outline,
      color: Colors.white,
    );
  }
}

// type -> "error", "success", "general"
showToast(BuildContext context, String type, String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.all(15),
      backgroundColor: getColor(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(children: [
        getIcon(type),
        SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                message,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}
