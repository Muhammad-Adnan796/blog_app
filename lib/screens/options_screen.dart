import 'package:blogapp/components/buttons.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: const Image(image: AssetImage("images/blogapp.jpg")),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(title: 'Login', onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                }),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                    title: 'Register',
                    onPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
