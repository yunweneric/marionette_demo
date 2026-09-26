import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marionette_demo/app.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

/// Debug builds only. `MarionetteBinding` registers the VM service extensions
/// the MCP server calls — that `if` is the whole integration. A release build
/// gets the stock binding, so nothing of Marionette ships to users.
///
/// The [PrintLogCollector] is what makes the agent's `get_logs` tool return
/// anything: without a collector the binding has no log source, and every
/// `debugPrint` in this app would stay in the terminal where the agent cannot
/// read it.
void main() {
  if (!kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MarionetteDemoApp());
    return;
  }

  final logs = PrintLogCollector();
  MarionetteBinding.ensureInitialized(
    MarionetteConfiguration(logCollector: logs),
  );

  runZoned(
    () => runApp(const MarionetteDemoApp()),
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, line);
        logs.addLog(line);
      },
    ),
  );
}
