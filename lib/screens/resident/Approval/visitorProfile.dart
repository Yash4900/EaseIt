import 'package:ease_it/screens/resident/Approval/approvalHome.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitorProfile extends StatefulWidget {
  

  @override
  _VisitorProfileState createState() => _VisitorProfileState();
}

class _VisitorProfileState extends State<VisitorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile",style: GoogleFonts.montserrat(textStyle:Helper().headingStyle),),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l'), fit: BoxFit.fill),
                  ),
                ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text("Amol Thopate",style: GoogleFonts.montserrat(textStyle:Helper().mediumStyle,),),
                        SizedBox(height: 10,),
                        Text("9898989890",style:GoogleFonts.montserrat(textStyle:Helper().normalStyle)),
                        SizedBox(height: 10,),
                        Row(
                          children: [Icon(Icons.call),
                          SizedBox(width: 10,),
                          Icon(Icons.share)
                          ],
                        )
                        
            
                      ],),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(children: [
                    Icon(Icons.home),
                    SizedBox(width: 10.0,),
                    Text("WORK IN BELOW HOUSES",style: GoogleFonts.montserrat(textStyle:Helper().mediumStyle)),
                  ],),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: 
                      [1,2,3,4,5,6].map((e)=>
                        Outline_button("B 605", Icons.call,()=>{})
                      ).toList()
                      
                  ,),)
                ],),
              ),
            )
          ],
        ),
      ),
      
    );
  }
}