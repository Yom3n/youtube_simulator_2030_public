import 'package:flutter/material.dart';

import '../../features/game/presentation/widgets/pop_up_ad.dart';
import '../domain/random_generator.dart';

class RandomPositionWidget extends StatefulWidget {
  const RandomPositionWidget({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<RandomPositionWidget> createState() => _RandomPositionWidgetState();
}

class _RandomPositionWidgetState extends State<RandomPositionWidget> {
  late double verticalValue;
  late double horizontalValue;

  @override
  void didChangeDependencies() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    verticalValue =
        (screenHeight - TextPopUpAd.MAX_AD_HEIGHT) * getRandomInt() / 100;
    horizontalValue =
        (screenWidth - TextPopUpAd.MAX_AD_WIDTH) * getRandomInt() / 100;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: horizontalValue,
      top: verticalValue,
      child: widget.child,
    );
  }
}
