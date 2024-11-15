import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../youtube_player/presentation/youtube_player_settings_cubit.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this.youtubePlayerSettingsCubit)
      : super(const SettingsState(SettingsStatus.initial));

  final YoutubePlayerSettingsCubit youtubePlayerSettingsCubit;

  void iInitialise() {
    youtubePlayerSettingsCubit.iInitialise();
    youtubePlayerSettingsCubit.stream.listen((youtubeState) {
      if (youtubeState.status == YoutubePlayerStatus.initialised) {
        emit(const SettingsState(SettingsStatus.initialized));
      }
    });
  }

  void iSave() {
    if (youtubePlayerSettingsCubit.state.isError()) {
      emit(const SettingsState(SettingsStatus.error));
    } else {
      youtubePlayerSettingsCubit.iSave();
      youtubePlayerSettingsCubit.stream.listen((event) {
        if (event.status == YoutubePlayerStatus.saved) {
          emit(const SettingsState(SettingsStatus.success));
        }
      });
    }
  }
}

enum SettingsStatus {
  initial,
  initialized,
  success,
  error,
}

class SettingsState extends Equatable {
  const SettingsState(this.settingsStatus);

  final SettingsStatus settingsStatus;

  @override
  List<Object?> get props => [settingsStatus];
}
