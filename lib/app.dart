import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/auth/login_screen.dart';

/// One `MaterialApp`, no router, no dependency injection.
///
/// Deliberately flat: `get_interactive_elements` walks the live widget tree
/// and returns what it finds, so every layer of indirection this app does not
/// have is a layer the agent does not have to read past. A talk demo is the
/// one place where the shallow architecture is the point.
class MarionetteDemoApp extends StatelessWidget {
  const MarionetteDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marionette Demo',
      debugShowCheckedModeBanner: false,
      theme: DemoTheme.light,
      // Demo 01 starts here. Demos 02 and 04 push on top of this screen
      // rather than replacing it, so `press_back_button` always has somewhere
      // to go.
      home: const LoginScreen(),
    );
  }
}
