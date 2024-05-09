// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second/copm/button.dart';
import 'package:second/copm/logo.dart';
import 'package:second/copm/textform.dart';

class login extends StatefulWidget {
  const login({super.key});
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: formState,
          child: Column(children: <Widget>[
            SizedBox(height: 200.0),
            Text(
              'Holek',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 172, 78, 212),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 166, 162, 162),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 214, 203, 215),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Email Address';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 214, 203, 215),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Not registered yet?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("signup");
                  },
                  child: Text('Register'),
                ),
              ],
            ),
            MaterialButton(
               height: 50,
               minWidth: 120,
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70)),
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("home");
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Please verify your email.',
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'Incorrect email or password. Please try again.',
                    ).show();
                  } catch (e) {
                    print('Error: $e');
                  }
                } else {
                  print("Enter the email and password");
                }
              },
              color: Colors.purple, 
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            
          ]),
        ),
      ),
    );
  }
}
