import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/ui/post/post_screen.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class VarifyWithNumber extends StatefulWidget {
  final String varification;
  const VarifyWithNumber({Key? key, required this.varification})
      : super(key: key);

  @override
  State<VarifyWithNumber> createState() => _VarifyWithNumberState();
}

class _VarifyWithNumberState extends State<VarifyWithNumber> {
  final numbercontroller = TextEditingController();
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: numbercontroller,
              decoration: InputDecoration(
                hintText: '6 digit code',
              ),
            ),
            RoundButton(
                title: 'Varify',
                onTap: () async{
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.varification,
                      smsCode: numbercontroller.text.toString());
                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                  } catch (e) {
                    Utlis().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
