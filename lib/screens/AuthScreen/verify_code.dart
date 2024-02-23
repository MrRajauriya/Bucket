


import 'package:bucket/widgets/round_button.dart';
import 'package:bucket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  // ignore: use_key_in_widget_constructors
  const VerifyCode({Key? key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loding = false;
  final auth = FirebaseAuth.instance;
  final verificationCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration:const InputDecoration(hintText: '6 Digit Code'),
            ),
            const SizedBox(
              height: 100,
            ),
            RoundButton(
                title: 'Verify',
                loading: loding,
                onTap: () async {
                  setState(() {
                    loding = true;
                  });
                  // ignore: non_constant_identifier_names
                  final Credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verificationCodeController.text.toString());
                  try {
                    await auth.signInWithCredential(Credential);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  } 
                  catch (e) {
                    setState(() {
                      loding = false;
                    });
                    utils().toastMessage(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }
}
