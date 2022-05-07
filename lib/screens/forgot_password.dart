import 'package:blogapp/components/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          title: const Text("Forgot Password"),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(

                              decoration: BoxDecoration(
                                  // color: Colors.purpleAccent,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 80,
                              width: 170,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                      CustomButton(
                          title: "Recover Password",
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {}

                            setState(() {
                              showSpinner = true;
                            });

                            try {
                              _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage("Please check your email,Link has been sent to your via email");
                              }).onError((error, stackTrace) {
                                toastMessage(error.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              });
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
