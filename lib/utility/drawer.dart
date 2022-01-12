import 'package:ease_it/screens/common/profile.dart';
import 'package:flutter/material.dart';

Drawer showDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Container(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/drawer_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        ListTile(
          title: Text(
            'All Members',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'My Vehicle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'Security Guards',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}
