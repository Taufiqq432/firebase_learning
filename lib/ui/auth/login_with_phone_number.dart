import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/ui/auth/varify_number.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithNumber extends StatefulWidget {
  const LoginWithNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithNumber> createState() => _LoginWithNumberState();
}

class _LoginWithNumberState extends State<LoginWithNumber> {
  final phonenumbercontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              controller: phonenumbercontroller,
              decoration: const InputDecoration(
                hintText: '+88 01*33 444 111',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                title: "Get the otp",
                onTap: () {
                  auth.verifyPhoneNumber(
                      phoneNumber: phonenumbercontroller.text,
                      verificationCompleted: (context) {},
                      verificationFailed: (e) {
                        Utlis().toastMessage(e.toString());
                      },
                      codeSent: (String varificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VarifyWithNumber(
                                      varification: varificationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (f) {
                        Utlis().toastMessage(f.toString());
                      });
                })
          ],
        ),
      ),
    );
  }
}
