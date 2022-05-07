import 'dart:async';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/options_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // final user = auth.currentUser;
    if (auth.currentUser == null) {
      Timer(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OptionScreen(),
          ),
        ),
      );
    }else{
      Timer(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen()
                ,
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage("images/blogapplogo.png"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              "Blog App!",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
