import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/assets.dart';
import '../../blocs/player_cubit/player_cubit.dart';
import 'ui.dart';

class HealthCounterUi extends StatelessWidget {
  const HealthCounterUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) => SizedBox(
        width: 110,
        child: UiBackground(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(
                state.health,
                (index) => Image.asset(
                      IconAssets.heart,
                      width: 15,
                    )).toList(),
          ),
        ),
      ),
    );
  }
}
