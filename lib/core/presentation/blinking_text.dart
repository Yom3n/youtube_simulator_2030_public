import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  const BlinkingText(
      {Key? key, required this.text, this.fontWeight = FontWeight.normal})
      : super(key: key);
  final String text;
  final FontWeight fontWeight;

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animation;
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);
    animation =
        ColorTween(begin: Colors.white, end: Colors.transparent).animate(curve);

    animation.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    });

    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Text(
            widget.text,
            style: TextStyle(
                color: animation.value, fontWeight: widget.fontWeight),
          );
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
