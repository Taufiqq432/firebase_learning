import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/ui/auth/login_screen.dart';
import 'package:firebase_learning/utils/utils.dart';
import 'package:firebase_learning/widgets/round_button.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final formkey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstnameController.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void load() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailcontroller.text.toString(),
            password: passwordcontroller.text.toString())
        .then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utlis().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusNode firstname = FocusNode();
    FocusNode lastname = FocusNode();
    FocusNode email = FocusNode();
    FocusNode password = FocusNode();
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Sign-up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                        focusNode: firstname,
                        controller: firstnameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'First name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'require';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(lastname);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        focusNode: lastname,
                        controller: lastnamecontroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Last Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'require';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(email);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        focusNode: email,
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Email',
                            helperText: 'something@gmail.com',
                            prefixIcon: const Icon(Icons.email_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'require';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(password);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      focusNode: password,
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'require';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              RoundButton(
                title: 'Sign up',
                loading: loading,
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    load();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
