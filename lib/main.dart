import 'package:ease_it/firebase/authentication.dart';
import 'package:ease_it/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EaseIt',
        theme: ThemeData(
          primaryColor: Color(0xff1a73e8),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: Wrapper(),
      ),
    );
  }
}
