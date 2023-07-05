import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/login': (context) => const LoginPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/homepage': (context) => HomePage(),
          '/register': (context) => const RegisterPage()
        },
      );
    }
    );
  }
}