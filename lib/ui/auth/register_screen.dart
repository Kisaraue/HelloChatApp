import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/ui/main/main_screen.dart';
import 'package:hello_chat/utils/alerts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _PageState();
}

class _PageState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _name,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email address",
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pwd,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff6226c5),
                ),
                onPressed: signupWithEmail,
                child: const Text(
                  'Sign Up',

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signupWithEmail() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _pwd.text);
      if (userCredential.user != null) {
        String email = _email.text;
        await FirebaseFirestore.instance.doc('chat_users/$email').set({
          "profile_pic": "",
          "full_name": _name.text,
          "email": email,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false);
      } else {
        Alerts.showMessage(context, "User registration failed!");
      }
    } catch (e) {
      Alerts.showMessage(context, 'Error in sign up: ${e.toString()}');
    }
  }
}
