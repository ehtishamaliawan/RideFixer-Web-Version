import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart'; // Added for MultiProvider
import 'src/services/bike_provider.dart'; // Added for BikeProvider
import 'src/services/reminder_provider.dart';
import 'src/services/service_log_provider.dart';
import 'src/services/theme_provider.dart';
import 'src/app.dart';

import 'dart:async';
import 'dart:io';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (kIsWeb) {
        // databaseFactory = databaseFactoryFfiWeb;
      } else if (Platform.isWindows || Platform.isLinux) {
        // Initialize FFI for Windows and Linux
        // sqfliteFfiInit();
        // databaseFactory = databaseFactoryFfi;
      }

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => BikeProvider()),
            ChangeNotifierProvider(create: (context) => ReminderProvider()),
            ChangeNotifierProvider(create: (context) => ServiceLogProvider()),
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ],
          child: const RideFixerApp(),
        ),
      );
    },
    (error, stack) {
      // Production: Log to Crashlytics/Sentry here
      print('CRITICAL APP ERROR: $error');
      print(stack);
    },
  );
}
