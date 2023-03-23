import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.dominant,
        backgroundColor: AppColors.secondary,
      ),
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
    );
  }
}
