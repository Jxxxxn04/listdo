import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:listdo/start_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'home_page/providers/list_provider.dart';
import 'list_page/providers/item_provider.dart';
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
          ChangeNotifierProvider(create: (_) => ItemProvider())
        ],
        child: const MyApp()
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: const FullScreenWidget(
         child:  _TempNoConnWidget()  // TODO : Make a better no Internet widget
      ),
      online: Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: StartPage(),
        );
      }
      ),
    );
  }
}

class _TempNoConnWidget extends StatelessWidget {
  const _TempNoConnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const Text("Kein Internet!"),
    );
  }
}
