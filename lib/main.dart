import 'package:flutter/material.dart';
import 'package:flutter_notification/local_notify_manager.dart';
import 'package:flutter_notification/test_notify_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotifyManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: TextNotifyScreen());
  }
}
