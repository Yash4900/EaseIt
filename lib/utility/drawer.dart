import 'package:ease_it/screens/common/events.dart';
import 'package:ease_it/screens/common/profile.dart';
import 'package:ease_it/screens/resident/myVehicle.dart';
import 'package:ease_it/screens/resident/myVisitors.dart';
import 'package:ease_it/screens/common/all_residents_info.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/screens/common/all_security_guards_info.dart';

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        ListTile(
          title: Text(
            'Events',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventsView()));
          },
        ),
        ListTile(
          title: Text(
            'All Members',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResidentInfoPage()));
          },
        ),
        ListTile(
          title: Text(
            'My Vehicle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyVehicle()));
          },
        ),
        ListTile(
          title: Text(
            'My Visitors',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyVisitors()));
          },
        ),
        ListTile(
          title: Text(
            'Security Guards',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SecurityGuardInfo()));
          },
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
