import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/game/domain/ad_content_generator.dart';
import '../features/game/domain/game_manager.dart';
import '../features/game/presentation/blocs/game_cubit/game_cubit.dart';
import '../features/game/presentation/blocs/player_cubit/player_cubit.dart';
import '../features/game/presentation/pages/game_page.dart';
import '../features/menu/menu_page.dart';
import '../features/settings/presentation/blocs/settings_cubit.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/youtube_player/data/repositories/youtube_player_repository.dart';
import '../features/youtube_player/presentation/youtube_player_settings_cubit.dart';
import '../service_locator.dart';

MaterialPageRoute<void> mainMenuRoute() {
  return MaterialPageRoute<void>(builder: (context) {
    return const MenuPage();
  });
}

MaterialPageRoute<void> gameRoute() {
  return MaterialPageRoute<void>(builder: (context) {
    final gameManager = GameManager(
      adGenerator: AdGenerator(AdContentGenerator()),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameCubit>(
          create: (BuildContext context) => GameCubit(gameManager),
        ),
        BlocProvider<PlayerCubit>(
          create: (context) => PlayerCubit(gameManager),
        ),
        BlocProvider<YoutubePlayerSettingsCubit>(
          create: (context) =>
              YoutubePlayerSettingsCubit(YoutubePlayerRepository(sl())),
        )
      ],
      child: const GamePage(),
    );
  });
}

MaterialPageRoute<void> settingsRoute() {
  return MaterialPageRoute<void>(builder: (context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<YoutubePlayerSettingsCubit>(
          create: (context) =>
              YoutubePlayerSettingsCubit(YoutubePlayerRepository(sl())),
        ),
        BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit(BlocProvider.of(context)))
      ],
      child: const SettingsPage(),
    );
  });
}
