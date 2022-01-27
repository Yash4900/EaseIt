import 'package:ease_it/screens/common/events/events.dart';
import 'package:ease_it/screens/common/profile.dart';
import 'package:ease_it/screens/resident/myVehicle.dart';
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
          leading: Icon(Icons.person_outline_sharp),
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.calendar_today_rounded),
          title: Text(
            'Events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventsView()));
          },
        ),
        ListTile(
          leading: Icon(Icons.group_outlined),
          title: Text(
            'All Members',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResidentInfoPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.time_to_leave),
          title: Text(
            'My Vehicle',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyVehicle()));
          },
        ),
        ListTile(
          leading: Icon(Icons.security_outlined),
          title: Text(
            'Security Guards',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SecurityGuardInfo()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {},
        ),
      ],
    ),
  );
}
