// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bucket/screens/AuthScreen/login_screen.dart';
import 'package:bucket/screens/BLE_Screen/flutter_blue_app.dart';
import 'package:bucket/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userEmail = '';
  late String userName = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  get firebaseAuthProvider => null;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'Email not available';
        userName = user.displayName ?? 'Name is not available';

        if (user.providerData.isNotEmpty) {
          userName = user.providerData[0].displayName ?? userName;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
            backgroundColor: Colors.blue,
            title: Text(
              "HomeScreen",
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlutterBlueApp()));
                  },
                  icon: Icon(
                    Icons.bluetooth,
                    // color: Colors.white,
                  )),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Text(
                        userName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        userEmail,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  
                  onTap: () {
                    // Update the state of the app

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    auth.signOut().then((value) async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewLogin()));
                      if (GoogleSignIn().currentUser != null) {
                        await GoogleSignIn().signOut();
                      }

                      try {
                        await GoogleSignIn().disconnect();
                      } catch (e) {
                        Logger().d('failed to disconnect on signout');
                      }

                      await _read(firebaseAuthProvider).signOut();
                    }).onError((error, stackTrace) {
                      utils().toastMessage(error.toString());
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

// ignore: camel_case_types
class _read {
  _read(firebaseAuthProvider);

  signOut() {}
}

class Logger {
  void d(String s) {}
}
