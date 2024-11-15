import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/youtube_video.dart';
import '../data/repositories/youtube_player_repository.dart';

class YoutubePlayerSettingsCubit extends Cubit<YoutubePlayerSettingsState> {
  YoutubePlayerSettingsCubit(this.youtubePlayerRepository)
      : super(
          const YoutubePlayerSettingsState(
              youtubeVideo: YoutubeVideo.empty(),
              status: YoutubePlayerStatus.notInitialised),
        );

  final YoutubePlayerRepository youtubePlayerRepository;

  Future<void> iInitialise() async {
    if (state.status == YoutubePlayerStatus.notInitialised) {
      final video = await Future.delayed(
          Duration.zero, () => youtubePlayerRepository.getYoutubeVideo());
      emit(YoutubePlayerSettingsState(
          youtubeVideo: video, status: YoutubePlayerStatus.initialised));
    }
  }

  Future<void> iSetVideo(String url) async {
    if (url.isEmpty) {
      emit(state.copyWith(status: YoutubePlayerStatus.errorEmpty));
      return;
    }
    if (YoutubeVideo(url).isValid) {
      emit(YoutubePlayerSettingsState(
          youtubeVideo: YoutubeVideo(url),
          status: YoutubePlayerStatus.initialised));
    } else {
      emit(state.copyWith(status: YoutubePlayerStatus.errorBadUrl));
    }
  }

  Future<void> iSave() async {
    final bool succeed =
        await youtubePlayerRepository.setVideo(state.youtubeVideo);
    if (succeed) {
      emit(state.copyWith(status: YoutubePlayerStatus.saved));
      return;
    } else {
      emit(state.copyWith(status: YoutubePlayerStatus.error));
      return;
    }
  }

  Future<void> iResetToDefaultVideo() async {
    final bool succeed = await youtubePlayerRepository.resetToDefaultVideoId();
    if (succeed) {
      final youtubeVideo = youtubePlayerRepository.getYoutubeVideo();
      emit(const YoutubePlayerSettingsState(
          youtubeVideo: YoutubeVideo.empty(),
          status: YoutubePlayerStatus.notInitialised));
      emit(YoutubePlayerSettingsState(
          youtubeVideo: youtubeVideo, status: YoutubePlayerStatus.initialised));
    } else {
      emit(state.copyWith(status: YoutubePlayerStatus.error));
    }
  }
}

class YoutubePlayerSettingsState extends Equatable {
  const YoutubePlayerSettingsState(
      {required this.youtubeVideo, required this.status});

  final YoutubeVideo youtubeVideo;
  final YoutubePlayerStatus status;

  bool isError() =>
      status == YoutubePlayerStatus.errorEmpty ||
      status == YoutubePlayerStatus.errorBadUrl ||
      status == YoutubePlayerStatus.error;

  @override
  List<Object?> get props => [youtubeVideo, status];

  @override
  bool? get stringify => true;

  YoutubePlayerSettingsState copyWith({
    YoutubeVideo? youtubeVideo,
    YoutubePlayerStatus? status,
  }) {
    return YoutubePlayerSettingsState(
        youtubeVideo: youtubeVideo ?? this.youtubeVideo,
        status: status ?? this.status);
  }
}

enum YoutubePlayerStatus {
  notInitialised,
  initialised,
  saved,
  errorEmpty,
  errorBadUrl,
  error,
}
