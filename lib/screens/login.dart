import 'package:blogapp/screens/forgot_password.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/buttons.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isobscure = true;

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.purpleAccent,
                                borderRadius: BorderRadius.circular(20)),
                            height: 70,
                            width: 150,
                            child: const Center(
                                child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ))),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter Email" : null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Email",
                            labelStyle: const TextStyle(
                              // color: Colors.purpleAccent,
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              // color: Colors.purpleAccent,
                            ),
                            hintText: "Email",
                            ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: _isobscure,
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter Password" : null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Password",
                            labelStyle: const TextStyle(
                              // color: Colors.purpleAccent,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isobscure = !_isobscure;
                                  });
                                },
                                icon: Icon(_isobscure
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            prefixIcon: const Icon(
                              Icons.lock,
                              // color: Colors.purpleAccent,
                            ),
                            hintText: "Password",
                           ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text("Forgot Password?"))),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomButton(
                          title: "Login",
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {}

                            setState(() {
                              showSpinner = true;
                            });

                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email.toString().trim(),
                                      password: password.toString().trim());
                              if (user != null) {
                                toastMessage("User Succesfully LogedIn");
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              toastMessage(e.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }

  void toastMessage(message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purpleAccent,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
