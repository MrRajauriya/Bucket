import 'package:bucket/screens/AuthScreen/verify_code.dart';
import 'package:bucket/widgets/round_button.dart';
import 'package:bucket/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loding = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              decoration: const InputDecoration(hintText: '+91 012 3456 789'),
            ),
            const SizedBox(
              height: 100,
            ),
            RoundButton(
                title: 'Login',
                loading: loding,
                onTap: () {
                  setState(() {
                    loding = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loding = false;
                        });
                      },
                      verificationFailed: (e) {
                        utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCode(
                              verificationId: verificationId,
                            ),
                          ),
                        );
                        setState(() {
                          loding = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        utils().toastMessage(e.toString());
                        setState(() {
                          loding = false;
                        });
                      });
                })
          ],
        ),
      ),
    );
  }
}
