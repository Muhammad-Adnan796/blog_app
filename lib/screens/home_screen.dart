import 'package:blogapp/screens/add_post.dart';
import 'package:blogapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child("Posts");
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();

  String search = "";


 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(


        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("Home Page"),
          elevation: 20,
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPostScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                )),
            InkWell(
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogInScreen(),
                      ),
                    );
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.logout),
                )),
          ],
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    search = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Search with blog title",
                    labelStyle: const TextStyle(
                        // color: Colors.purpleAccent,
                        ),
                    prefixIcon: const Icon(
                      Icons.search,
                      // color: Colors.purpleAccent,
                    ),
                  )),
            ),
            Expanded(
                child: FirebaseAnimatedList(
              query: dbRef.child("Post List"),
              defaultChild: const Center(
                  child: CircularProgressIndicator(
                semanticsValue: "20",
              )),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                String tempTitle = snapshot.child("pTitle").value.toString();
                if (searchController.text.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue.shade300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * .30,
                                  placeholder: "images/blogapplogo.png",
                                  image: snapshot
                                      .child("pImage")
                                      .value
                                      .toString()),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                snapshot.child("pTitle").value.toString(),
                                // style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                snapshot.child("pDescription").value.toString(),
                                // style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (tempTitle.toLowerCase().contains(
                      searchController.text.toString(),
                    )) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * .30,
                                placeholder: "images/blogapplogo.png",
                                image:
                                    snapshot.child("pImage").value.toString()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              snapshot.child("pTitle").value.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              snapshot.child("pDescription").value.toString(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )),
          ],
        ),

      ),
    );
  }
}


