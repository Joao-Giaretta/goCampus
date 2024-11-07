import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_screen.dart';
import 'company_evaluation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(

      //Page apenas para teste
      context, MaterialPageRoute(builder: (context) => EvaluationPage(company: {"name": "Ferrari"})));    }
      // context, MaterialPageRoute(builder: (context) => SearchScreen()))); 

  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      _checkLoginStatus();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // Navega para LoginScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo_go_campus.png', // Caminho da sua logo
          height: 200, // Altura da logo
        ),
      ),
    );
  }
}
