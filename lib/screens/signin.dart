import 'package:blogapp/components/buttons.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isobscure = true;

  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

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
          title: Text("Create Account"),
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
                              child: Center(
                                  child: Text(
                                "Register",
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
                            labelStyle: TextStyle(
                              // color: Colors.purpleAccent,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              // color: Colors.purpleAccent,
                            ),
                            hintText: "Email",
                          ),
                        ),
                        SizedBox(
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
                                  : Icons.visibility_off),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              // color: Colors.purpleAccent,
                            ),
                            hintText: "Password",
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomButton(
                            title: "Register",
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {}

                              setState(() {
                                showSpinner = true;
                              });

                              try {
                                final user =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email.toString().trim(),
                                        password: password.toString().trim());
                                if (user != null) {
                                  toastMessage("User Succesfully Created");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              } catch (e) {
                                toastMessage(e.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            })
                      ],
                    )),
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
