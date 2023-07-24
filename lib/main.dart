import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listdo/start_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'home_page/providers/list_provider.dart';
import 'screens.dart';

void main() async {
  await Future.delayed(const Duration(milliseconds: 200));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ListProvider()),
        ],
        child: const MyApp()
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/startpage',
        routes: {
          '/startpage': (context) => const StartPage(),
          '/login': (context) => const LoginPage(),
          '/homepage': (context) => HomePage(),
          '/register': (context) => const RegisterPage()
        },
      );
    }
    );
  }
}