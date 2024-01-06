import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'HomeScreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(milliseconds: 5800),
        ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>HomeScreen()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 240, 241),
      body: Center(
        child: Lottie.asset(
          'Assets/Animation/Loading.json',
          width: 200,
          height: 200,
        ),

      ),
    );
  }
}