import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_chat/ui/auth/login_screen.dart';
import 'package:hello_chat/ui/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _PageState();
}

class _PageState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfUserLoggedIn();
  }

  void checkIfUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(const Duration(seconds: 3), showMain);
    } else {
      Future.delayed(const Duration(seconds: 3), showLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff070c44),
        body: Center(
          child:Image(
            image: AssetImage("assets/images/logo.png"),
            width: 100,
          )
        ),
      ),
    );
  }

  void showLogin() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  void showMain() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false);
  }
}
