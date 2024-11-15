import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/game/data/game_over.dart';
import '../features/game/presentation/dialogs/game_over_dialog.dart';
import '../features/high_score/data/repositories/high_score_repository.dart';
import '../features/high_score/presentation/blocs/high_score_cubit.dart';
import '../service_locator.dart';

Future<void> showGameOverDialog({
  required BuildContext context,
  required VoidCallback onRestartTapped,
  required GameOver gameOver,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => BlocProvider<HighScoreCubit>(
      create: (context) => HighScoreCubit(
        HighScoreRepository(sl()),
      ),
      child: GameOverDialog(
        onRestartTapped: onRestartTapped,
        gameOver: gameOver,
      ),
    ),
  );
}
