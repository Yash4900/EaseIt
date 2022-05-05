import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/screens/common/daily_helpers/daily_helpers_list.dart';
import 'package:ease_it/screens/common/events/events.dart';
import 'package:ease_it/screens/common/profile/profile.dart';
import 'package:ease_it/screens/common/info/all_residents_info.dart';
import 'package:ease_it/utility/flat_data_operations.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:flutter/material.dart';
import 'package:ease_it/screens/common/info/all_security_guards_info.dart';

Container showDrawer(BuildContext context) {
  Globals g = Globals();
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      g.society,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ]),
          ),
          ListTile(
            title: Text(
              g.fname + ' ' + g.lname,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  g.role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                g.status == "accepted" &&
                        (g.role == "Resident" || g.role == "Secretary")
                    ? Text(
                        FlatDataOperations(
                          hierarchy: g.hierarchy,
                          flatNum: Map<String, String>.from(g.flat),
                        ).returnStringFormOfFlatMap(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          ListTile(
            leading: Image.asset('assets/profile.png', width: 20),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Image.asset('assets/calendar.png', width: 20),
            title: Text(
              'Events',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventsView()));
            },
          ),
          ListTile(
            leading: Image.asset('assets/users.png', width: 20),
            title: Text(
              'All Members',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResidentInfoPage()));
            },
          ),
          ListTile(
            leading: Image.asset('assets/user-plus.png', width: 20),
            title: Text(
              'Daily Visitors',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DailyHelpersList()));
            },
          ),
          ListTile(
            leading: Image.asset('assets/shield.png', width: 20),
            title: Text(
              'Security Guards',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecurityGuardInfo()));
            },
          ),
          ListTile(
            leading: Image.asset('assets/logout.png', width: 20),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await Auth().logout();
            },
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Text(
                      'Ease',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'It',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      ' .',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff037DD6)),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'v 1.0.0',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Container showCustomDrawer(BuildContext context) {
  Globals g = Globals();
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      g.society,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ]),
          ),
          ListTile(
            title: Text(
              g.fname + ' ' + g.lname,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              g.role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline_sharp,
              color: Colors.black87,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black87,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await Auth().logout();
            },
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Text(
                      'Ease',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'It',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      ' .',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff037DD6)),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'v 1.0.0',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
