import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dialogs.dart';
import '../../../../core/domain/random_generator.dart';
import '../../../../core/presentation/base_page.dart';
import '../../../../core/routes.dart';
import '../../../ad_mob/ad_mob.dart';
import '../../../youtube_player/presentation/game_page_youtube_player.dart';
import '../../data/models.dart';
import '../blocs/game_cubit/game_cubit.dart';
import '../blocs/player_cubit/player_cubit.dart';
import '../widgets/pop_up_ad.dart';
import '../widgets/ui/player_hit_overlay.dart';
import '../widgets/ui/point_counter_ui.dart';
import '../widgets/ui/ui.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameCubit gameCubit;
  late final PlayerCubit playerCubit;

  @override
  void didChangeDependencies() {
    gameCubit = BlocProvider.of<GameCubit>(context);
    playerCubit = BlocProvider.of<PlayerCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, mainMenuRoute());
        return false;
      },
      child: BasePage(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocListener<GameCubit, GameState>(
            listener: (context, state) async {
              if (state is GameStateGameOver) {
                if (_shouldShowFullScreenAd(state)) {
                  final ad = await AdMob.instance.getRepeatGameFullScreenAd();
                  await ad?.show();
                }
                await showGameOverDialog(
                  context: context,
                  onRestartTapped: () async {
                    gameCubit.iGameStarted();
                  },
                  gameOver: state.gameOver,
                );
              }
            },
            child: BlocBuilder<GameCubit, GameState>(
              builder: (BuildContext context, GameState state) =>
                  Stack(children: <Widget>[
                const Positioned.fill(child: GamePageYoutubePlayer()),
                ...state.activeAds.map(
                  (Ad ad) => AdBodyGenerator(
                    key: Key(ad.uuid),
                    ad: ad,
                    onAdBodyTapped: (ad) async => playerCubit.iDamagePlayer(ad),
                    onCloseTapped: (ad) => gameCubit.iAdKilled(ad),
                  ),
                ),
                const Positioned.fill(
                    child: IgnorePointer(child: PlayerHitOverlay())),
                const Positioned(
                    left: 15, child: IgnorePointer(child: HealthCounterUi())),
                const Positioned(
                    right: 15, child: IgnorePointer(child: PointCounterUi())),
                Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 15,
                    child: const IgnorePointer(child: AdsCounterUi())),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowFullScreenAd(GameStateGameOver state) {
    if (state.gameOver.gameOverCause == GameOverCause.tooManyAds) {
      return true;
    } else {
      final a = getRandomInt(max: 2);
      return a == 0;
    }
  }
}
