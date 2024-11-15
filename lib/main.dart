import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/presentation/colors.dart';
import 'features/ad_mob/ad_mob.dart';
import 'features/menu/menu_page.dart';
import 'service_locator.dart' as service_locator;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdMob.instance.init();
  service_locator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
        title: 'Youtube simulator 2020',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: MyColors.primary,
          colorScheme: ColorScheme.dark(
            background: Colors.black,
            primary: MyColors.primary,
            secondary: MyColors.secondary,
            error: MyColors.error,
          ),
        ),
        home: const MenuPage());
  }
}
