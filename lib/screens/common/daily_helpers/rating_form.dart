import 'dart:ui';

import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/acknowledgement/toast.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RatingForm extends StatefulWidget {
  final double rating;
  final String comment;
  final String id;
  RatingForm(
      {Key key,
      @required this.rating,
      @required this.comment,
      @required this.id})
      : super(key: key);

  @override
  State<RatingForm> createState() => _RatingFormState();
}

class _RatingFormState extends State<RatingForm> {
  double rating;
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Globals g = Globals();
  @override
  void initState() {
    // TODO: implement initState
    rating = widget.rating;
    _controller.text = widget.comment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rating',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: rating.toDouble(),
                        onChanged: (val) {
                          rating = val;
                        },
                        min: 0,
                        max: 5,
                        divisions: 1,
                        label: '*',
                        activeColor: Color(0xff037DD6),
                        inactiveColor: Colors.black45,
                      ),
                      Text(
                        'Comment',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter comments'),
                        validator: (value) => value.length == 0
                            ? 'This is a required field'
                            : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              await Database().rateDailyHelper(
                                  g.society,
                                  widget.id,
                                  FirebaseAuth.instance.currentUser.uid,
                                  rating,
                                  _controller.text);
                              showToast(context, 'success', 'Success!',
                                  'Comment added successfully');
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Text(
                            'Publish',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff037DD6)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
