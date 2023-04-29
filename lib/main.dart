import 'package:currency_convertor_app/views/screens/homepage.dart';
import 'package:currency_convertor_app/views/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      routes: {
        '/': (context) => const Homepage(),
        'splash_screen': (context) => const SplashScreen(),
      },
    ),
  );
}
