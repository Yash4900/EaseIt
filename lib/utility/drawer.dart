import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/screens/common/events/events.dart';
import 'package:ease_it/screens/common/profile/profile.dart';
import 'package:ease_it/screens/resident/myVehicle.dart';
import 'package:ease_it/screens/common/info/all_residents_info.dart';
import 'package:ease_it/screens/security/add_vehicle.dart/add_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/screens/common/info/all_security_guards_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Container showDrawer(BuildContext context, String role, String name) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.6,
    child: Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/apartment.PNG'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.srcATop),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    role,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventsView()));
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
            leading: Icon(FontAwesomeIcons.car),
            title: Text(
              role == "Security Guard" ? 'Add Vehicle' : 'My Vehicle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => role == "Security Guard"
                          ? AddVehicle()
                          : MyVehicle()));
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
            onTap: () async {
              await Auth().logout();
            },
          ),
        ],
      ),
    ),
  );
}
