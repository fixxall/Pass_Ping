import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_ping_project/pages/authPage.dart';
import 'package:pass_ping_project/pages/homePage.dart';
import 'package:pass_ping_project/settings/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.yy

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: GoogleFonts.rubik(),
      child: MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        title: 'Passping Project',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen.shade200),
          useMaterial3: true,
        ),
        // routes: PageRoutes.routes,
      ),
    );
  }
}
