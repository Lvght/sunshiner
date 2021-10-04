import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunshiner/screens/app_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFFF4A4A),
          onPrimary: Colors.black87,
          secondary: Color(0xFFFF4A4A),
          background: Color(0xFF00FF00),
          brightness: Brightness.light,
          onBackground: Color(0xFA000000),
          onSurface: Color(0xFFFAFAFA),
          error: Colors.red,
          onError: Colors.black,
          onSecondary: Colors.blue,
          primaryVariant: Colors.red,
          secondaryVariant: Colors.pink,
          surface: Colors.green,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          centerTitle: false,
          backgroundColor: const Color(0xFFECECEC),
        ),
        scaffoldBackgroundColor: const Color(0xFFECECEC),
        textTheme: TextTheme(
            headline1: GoogleFonts.ptSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodyText1: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      home: const AppWrapper(),
    );
  }
}
