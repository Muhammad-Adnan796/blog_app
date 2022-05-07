import 'dart:io';
import 'package:blogapp/components/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen( {Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  void dialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    getCameraImage();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getGalleryImage();

                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(" Upload Post"),
          elevation: 20,
          shadowColor: Colors.grey,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    dialog();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: _image != null
                        ? ClipRect(
                            child: Image.file(
                            _image!.absolute,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 100,
                              height: 100,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                            prefixIcon: const Icon(Icons.person),
                            hintText: "Enter Title",
                            labelText: "Enter Title",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            prefixIcon: const Icon(Icons.description),
                            hintText: "Enter Description",
                            labelText: "Enter Description",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(
                    title: "Upload Image",
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        int date = DateTime.now().microsecondsSinceEpoch;

                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref("/blog$date");
                        UploadTask uploadTask = ref.putFile(_image!.absolute);
                        await Future.value(uploadTask);
                        var newUrl = await ref.getDownloadURL();

                        final User? user = _auth.currentUser;

                        postRef.child("Post List").child(date.toString()).set({
                          "pId": date.toString(),
                          "pImage": newUrl.toString(),
                          "pTime": date.toString(),
                          "pTitle": titleController.text.toString(),
                          "pDescription": descriptionController.text.toString(),
                          "uEmail": user!.email.toString(),
                          "uid": user.uid.toString(),
                        }).then((value) {
                          toastMessage("Post Published");
                          setState(() {
                            showSpinner = false;
                          });
                        }).onError((error, stackTrace) {
                          toastMessage(error.toString());
                          setState(() {
                            showSpinner = false;
                          });
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
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
