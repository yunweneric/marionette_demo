import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marionette_demo/app.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

/// Debug builds only. `MarionetteBinding` registers the VM service extensions
/// the MCP server calls — the whole integration is this `if`. A release build
/// gets the stock binding, so nothing of Marionette ships to users.
void main() {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(const MarionetteDemoApp());
}
