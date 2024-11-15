import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/player_cubit/player_cubit.dart';
import 'ui.dart';

class PointCounterUi extends StatelessWidget {
  const PointCounterUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) => UiBackground(
        child: PointCounterUiBase(
          points: state.points,
        ),
      ),
    );
  }
}

class PointCounterUiBase extends StatelessWidget {
  const PointCounterUiBase({Key? key, required this.points}) : super(key: key);
  final int points;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.monetization_on, color: Colors.white),
        Text(
          '  $points',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
