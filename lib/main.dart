import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tesla_animated_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesla Animated App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: const HomeScreen(),
    );
  }
}
