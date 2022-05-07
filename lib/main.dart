import 'package:blogapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.cyan,
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black),
            bodyText1: TextStyle(color: Colors.black),
          )),
      home: const SplashScreen(),
    );
  }
}
