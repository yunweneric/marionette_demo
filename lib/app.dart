import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/auth/login_screen.dart';

class MarionetteDemoApp extends StatelessWidget {
  const MarionetteDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marionette Demo',
      debugShowCheckedModeBanner: false,
      theme: DemoTheme.light,
      home: const LoginScreen(),
    );
  }
}
