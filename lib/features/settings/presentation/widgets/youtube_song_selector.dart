import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/presentation/colors.dart';
import '../../../../core/presentation/screen_utils.dart';
import '../../../youtube_player/presentation/youtube_player_settings_cubit.dart';

class YoutubeSongSelector extends StatefulWidget {
  const YoutubeSongSelector({Key? key}) : super(key: key);

  @override
  State<YoutubeSongSelector> createState() => _YoutubeSongSelectorState();
}

class _YoutubeSongSelectorState extends State<YoutubeSongSelector> {
  late final TextEditingController videoTextController;

  late final YoutubePlayerSettingsCubit youtubePlayerCubit;
  YoutubePlayerController? youtubePlayerController;

  @override
  void initState() {
    videoTextController = TextEditingController();
    youtubePlayerCubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubePlayerSettingsCubit, YoutubePlayerSettingsState>(
      builder: (context, state) {
        if (state.status == YoutubePlayerStatus.notInitialised) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == YoutubePlayerStatus.initialised) {
          videoTextController.text = state.youtubeVideo.url;
          videoTextController.selection =
              TextSelection.collapsed(offset: videoTextController.text.length);
          youtubePlayerController ??= YoutubePlayerController(
              initialVideoId: state.youtubeVideo.id,
              flags: const YoutubePlayerFlags(autoPlay: false));
          youtubePlayerController?.load(state.youtubeVideo.id);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Music', style: TextStyle(fontSize: 24)),
            if (youtubePlayerController != null)
              YoutubePlayer(
                controller: youtubePlayerController!,
              ),
            TextField(
              controller: videoTextController,
              decoration: InputDecoration(
                  label: const Text('Youtube video url'),
                  errorText: _getUrlError(state),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.restart_alt),
                    onPressed: () => youtubePlayerCubit.iResetToDefaultVideo(),
                  )),
              onSubmitted: (videoId) => youtubePlayerCubit.iSetVideo(videoId),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _onSubmitUrl();
                },
                style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryLight),
                child: const Text('Submit Url'),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _onSubmitUrl() {
    hideKeyboard();
    return youtubePlayerCubit.iSetVideo(videoTextController.text);
  }

  ///Return null for no errors
  String? _getUrlError(YoutubePlayerSettingsState state) {
    switch (state.status) {
      case YoutubePlayerStatus.notInitialised:
        return 'Not initialized';
      case YoutubePlayerStatus.errorEmpty:
        return "Can't be empty";
      case YoutubePlayerStatus.errorBadUrl:
        return 'Bad URL';
      case YoutubePlayerStatus.error:
        return 'An error occured when parins URL';
      case YoutubePlayerStatus.initialised:
        break;
      case YoutubePlayerStatus.saved:
        break;
    }
    return null;
  }

  @override
  void dispose() {
    videoTextController.dispose();
    youtubePlayerController?.dispose();
    super.dispose();
  }
}
