import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/ui/auth/register_screen.dart';
import 'package:hello_chat/ui/main/main_screen.dart';
import 'package:hello_chat/utils/alerts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _PageState();
}

class _PageState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070c44),
      appBar: AppBar(
        backgroundColor: Color(0xff6226c5),
        title: const Text("Hello Chat"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login to use',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                'Hello Chat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(
                height: 60,
              ),
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
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff6226c5),
                ),
                onPressed: loginWithEmail,
                child: const Text(
                  'Login with Email',
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                    ),
                    onTap: _signUp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginWithEmail() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email.text, password: _pwd.text);
      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
            (route) => false);
      } else {
        Alerts.showMessage(context, "Authentication failed!");
      }
    } catch (e) {
      Alerts.showMessage(context,
          'Authentication failed! ${e.toString()}');
    }
  }

  void loginWithGoogle() {}

  void _signUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }
}
