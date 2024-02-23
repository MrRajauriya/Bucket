// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:bucket/screens/home.dart';
import 'package:bucket/screens/AuthScreen/login_with_phone.dart';
import 'package:bucket/widgets/round_button.dart';
import 'package:bucket/screens/AuthScreen/signup_screen.dart';
import 'package:bucket/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({super.key});

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  bool isLoading = false;
  late SharedPreferences prefs;
  get provider => null;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    // ignore: non_constant_identifier_names
    auth.authStateChanges().listen((Event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var reslut = await googleSignIn.signIn();
      if (reslut == null) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      // ignore: empty_catches
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      print('Result $reslut');
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  void login() {
    setState(() {});
    auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      utils().toastMessage(value.user!.email.toString());
      utils().toastMessage("Login successful");

      var email = value.user!.email;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

      // Navigator.pushNamed(context, '/home');
      setState(() {
        saveEmail(email.toString());
      });
    }).onError((error, stackTrace) {
      utils().toastMessage("Login Failed");
      setState(() {});
    });
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myemail', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                    height: 100, child: Image.asset('assets/Image/Google.png')),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            helperText: 'enter email e.g jon@gmail.com',
                            prefix: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              prefix: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: RoundButton(
                      title: 'Login',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 1,
                      width: 120,
                      child: ColoredBox(color: Colors.black),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Or',
                      style: TextStyle(
                          color: Colors.black,
                         
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: 1,
                      width: 125,
                      child: ColoredBox(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (isLoading)
                  SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator())
                else
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Image.asset('assets/Image/Google.png'),
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              googleLogin();
                            },
                            child: Text(
                              'Signin with Google',
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginWithPhone()));
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Text(
                      'Login with phone number',style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont have an account'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),
              ]),
        ),
      ),
    ));
  }

  // Future handleGoogleSignIn() async {
  //   try {
  //     GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //     auth.signInWithProvider(googleAuthProvider).then((value) {
  //       // utils().toastMessage(value.user!.email.toString());
  //       utils().toastMessage("Login successful");

  //       Navigator.pushNamed(context, '/home');
  //       setState(() {
  //         loding = false;
  //       });
  //     });
  //     // Navigator.pushReplacement(
  //     //     context, MaterialPageRoute(builder: (context) => HomeScreen()));

  //     // ignore: empty_catches
  //   } catch (error) {}
  //   utils().toastMessage(toString());
  // }
}
