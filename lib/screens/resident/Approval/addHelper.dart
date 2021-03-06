import 'package:ease_it/screens/resident/Approval/helpers.dart';
import 'package:ease_it/utility/variables/helper.dart';
import 'package:flutter/material.dart';

class AddHelper extends StatefulWidget {
  @override
  _AddHelperState createState() => _AddHelperState();
}

class _AddHelperState extends State<AddHelper> {
  List<Map<String, String>> totalHelper = [
    {"name": "Milkman", "imageLink": "assets/milk.png"},
    {"name": "Newspaper", "imageLink": "assets/newspaper.png"},
    {"name": "Maid", "imageLink": "assets/001-maid.png"},
    {"name": "Electrician", "imageLink": "assets/002-electrician.png"},
    {"name": "Water Supplier", "imageLink": "assets/003-water-bottle.png"},
    {"name": "Driver", "imageLink": "assets/004-driver.png"},
    {"name": "Laundry", "imageLink": "assets/005-washing.png"},
    {"name": "Tuition Teacher", "imageLink": "assets/006-teacher.png"},
    {"name": "Cook", "imageLink": "assets/cooking.png"},
    {"name": "Car Cleaner", "imageLink": "assets/car-service.png"},
    {"name": "Gym Instructor", "imageLink": "assets/workout.png"},
    {"name": "Mechanic", "imageLink": "assets/mechanic.png"},
    {"name": "Plumber", "imageLink": "assets/plumber.png"},
    {"name": "Delivery", "imageLink": "assets/delivery-man.png"},
    {"name": "Technician", "imageLink": "assets/technical-support.png"},
    {"name": "Nannny", "imageLink": "assets/mother.png"},
    {"name": "Salesman", "imageLink": "assets/salesman.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: totalHelper
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyHelpers(
                                  dailyHelperType: e['name'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(e["imageLink"]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(e["name"], style: Helper().mediumStyle),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
