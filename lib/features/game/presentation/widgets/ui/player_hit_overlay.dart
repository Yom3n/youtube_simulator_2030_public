import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/player_cubit/player_cubit.dart';

class PlayerHitOverlay extends StatefulWidget {
  const PlayerHitOverlay({Key? key}) : super(key: key);

  @override
  State<PlayerHitOverlay> createState() => _PlayerHitOverlayState();
}

class _PlayerHitOverlayState extends State<PlayerHitOverlay> {
  static const int DURATION = 100;

  late final PlayerCubit playerCubit;
  bool gotDamaged = false;

  @override
  void didChangeDependencies() {
    playerCubit = BlocProvider.of<PlayerCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: playerCubit,
      listener: (context, state) {
        Future.delayed(Duration.zero, () {
          if (state is PlayerStateHit) {
            setState(() {
              gotDamaged = true;
            });
            Future.delayed(const Duration(milliseconds: DURATION), () {
              setState(() {
                gotDamaged = false;
              });
            });
          }
        });
      },
      child: AnimatedContainer(
        color: Colors.red.withAlpha(gotDamaged ? 250 : 0),
        duration: const Duration(milliseconds: DURATION),
      ),
    );
  }
}
