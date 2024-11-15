import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/base_page.dart';
import 'blocs/settings_cubit.dart';
import 'widgets/youtube_song_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsCubit settingsCubit;

  @override
  void didChangeDependencies() {
    settingsCubit = BlocProvider.of(context)..iInitialise();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state.settingsStatus == SettingsStatus.success) {
                Navigator.pushReplacementNamed(context, '/');
              }
              if (state.settingsStatus == SettingsStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fix above errors first')));
              }
            },
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state.settingsStatus == SettingsStatus.initial) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 50),
                    const YoutubeSongSelector(),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          onPressed: () {
                            settingsCubit.iSave();
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: SizedBox(
                    //     width: 240,
                    //     child: ElevatedButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //           primary: MyColors.primaryLight),
                    //       child: const Text('Discard Changes'),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 50),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
