import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen_utils.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        hideKeyboard();
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
