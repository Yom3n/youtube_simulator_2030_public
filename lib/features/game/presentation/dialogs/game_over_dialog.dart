import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/blinking_text.dart';
import '../../../../core/presentation/colors.dart';
import '../../../high_score/presentation/blocs/high_score_cubit.dart';
import '../../data/ad.dart';
import '../../data/game_over.dart';
import '../widgets/ui/point_counter_ui.dart';

class GameOverDialog extends StatefulWidget {
  const GameOverDialog({
    Key? key,
    required this.onRestartTapped,
    required this.gameOver,
  }) : super(key: key);

  final GameOver gameOver;

  final VoidCallback onRestartTapped;

  @override
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  late final HighScoreCubit highScoreCubit;

  @override
  void initState() {
    highScoreCubit = BlocProvider.of<HighScoreCubit>(context)
      ..updateHighScore(widget.gameOver.points);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: MyColors.primary,
      title: const Text('GAME OVER', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<HighScoreCubit, HighScoreState>(
              builder: (context, state) {
            return Column(
              children: [
                if (state.status == HighScoreStatus.newRecord)
                  const SizedBox(height: 5),
                if (state.status == HighScoreStatus.newRecord)
                  const BlinkingText(
                    text: 'NEW RECORD',
                    fontWeight: FontWeight.bold,
                  ),
                PointCounterUiBase(points: widget.gameOver.points),
                if (state.status != HighScoreStatus.newRecord)
                  const SizedBox(height: 5),
                if (state.status != HighScoreStatus.newRecord)
                  Text('High score: ${state.highScore.score}',
                      style: const TextStyle(fontSize: 12)),
              ],
            );
          }),
          const SizedBox(height: 15),
          GameOverCausePreview(
            gameOver: widget.gameOver,
          ),
        ],
      ),
      actions: [
        IconButton(
          iconSize: 50,
          onPressed: () {
            widget.onRestartTapped();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.restart_alt),
          color: MyColors.secondary,
        )
      ],
    );
  }
}

class GameOverCausePreview extends StatelessWidget {
  const GameOverCausePreview({Key? key, required this.gameOver})
      : super(key: key);
  final GameOver gameOver;

  @override
  Widget build(BuildContext context) {
    switch (gameOver.gameOverCause) {
      case GameOverCause.zeroHealth:
        assert(
            gameOver.ad != null, "When user is killed by ad, ad can't be null");
        return Column(
          children: [
            const Text('You had to find out about'),
            const SizedBox(height: 5),
            GameOverAdPreview(ad: gameOver.ad!),
          ],
        );
      case GameOverCause.tooManyAds:
        return const Column(
          children: [
            Text('Ads possessed your life. Fight harder next time!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
    }
  }
}

/// Generates widget that is shown in game over dialog, when user lost because
/// of taping the ad
class GameOverAdPreview extends StatelessWidget {
  const GameOverAdPreview({Key? key, required this.ad}) : super(key: key);
  final Ad ad;

  @override
  Widget build(BuildContext context) {
    switch (ad.adType) {
      case AdType.textAd:
        return Text((ad as TextAd).text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold));
      case AdType.starterAd:
        return Container();
    }
  }
}
