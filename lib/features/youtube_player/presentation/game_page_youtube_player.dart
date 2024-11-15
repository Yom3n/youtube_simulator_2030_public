import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../game/presentation/blocs/game_cubit/game_cubit.dart';
import 'youtube_player_settings_cubit.dart';

class GamePageYoutubePlayer extends StatefulWidget {
  const GamePageYoutubePlayer({Key? key, this.isPlayerReady}) : super(key: key);

  final Function(bool isPlayerReady)? isPlayerReady;

  @override
  _GamePageYoutubePlayerState createState() => _GamePageYoutubePlayerState();
}

class _GamePageYoutubePlayerState extends State<GamePageYoutubePlayer> {
  YoutubePlayerController? _controller;
  late final YoutubePlayerSettingsCubit youtubePlayerSettingsCubit;

  late PlayerState _playerState;
  bool playerHasListeners = false;

  @override
  void initState() {
    super.initState();
    _playerState = PlayerState.unknown;
  }

  @override
  void didChangeDependencies() {
    youtubePlayerSettingsCubit = BlocProvider.of(context);
    youtubePlayerSettingsCubit.iInitialise();
    super.didChangeDependencies();
  }

  void listener() {
    if (mounted) {
      setState(() {
        _playerState = _controller?.value.playerState ?? PlayerState.unknown;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubePlayerSettingsCubit, YoutubePlayerSettingsState>(
      builder: (context, state) {
        if (state.status == YoutubePlayerStatus.notInitialised) {
          return const CircularProgressIndicator();
        }
        if (state.status == YoutubePlayerStatus.initialised) {
          _controller ??= YoutubePlayerController(
            initialVideoId: state.youtubeVideo.id,
            flags: const YoutubePlayerFlags(
              enableCaption: false,
              autoPlay: false,
              disableDragSeek: true,
              hideControls: true,
              loop: true,
            ),
          );
          if (_controller != null && !playerHasListeners) {
            playerHasListeners = true;
            _controller?.addListener(listener);
          }
        }
        return BlocListener<GameCubit, GameState>(
          listener: (BuildContext context, state) {
            if (state is GameStateGameOver) {
              _controller?.pause();
            } else {
              if (_playerState == PlayerState.paused) {
                _controller?.play();
              }
            }
          },
          child: YoutubePlayer(
            controller: _controller!,
            onReady: () {
              _controller?.play();
              if (widget.isPlayerReady != null) {
                widget.isPlayerReady!(true);
              }
            },
          ),
        );
      },
    );
  }
}
