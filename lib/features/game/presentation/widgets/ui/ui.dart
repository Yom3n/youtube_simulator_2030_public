import 'package:flutter/material.dart';

export 'ads_counter_ui.dart';
export 'hp_counter_ui.dart';
export 'player_hit_overlay.dart';
export 'point_counter_ui.dart';

class UiBackground extends StatelessWidget {
  const UiBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.all(5),
      child: child,
    );
  }
}
