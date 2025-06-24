import 'package:flutter/material.dart';
import 'package:moduloa1/pages/genius.dart';
import 'package:moduloa1/pages/home.dart';
import 'package:moduloa1/pages/quiz.dart';
import 'package:moduloa1/styles/cores.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cores.azulClaro),
      ),
      routes: {
        '/home': (context) => const Home(),
        '/quiz': (context) => const Quiz(),
        '/genius': (context) => const Genius(),
      },
      initialRoute: '/home',
    );
  }
}
