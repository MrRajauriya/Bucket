// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace

import 'package:bucket/screens/AuthScreen/login_screen.dart';
import 'package:bucket/widgets/round_button.dart';
import 'package:bucket/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _NewLoginState();
}

class _NewLoginState extends State<SignUp> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
   
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Sign up',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                            color: Colors.purple,
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
                              color: Colors.purple,
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
                height: 50,
              ),
              RoundButton(
                  title: 'Sign up',
                  loading: loading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  }),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewLogin()));
                      },
                      child: Text('Login'))
                ],
              )
            ]),
      ),
    );
  }
}
