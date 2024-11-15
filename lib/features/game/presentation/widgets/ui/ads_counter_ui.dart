import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/game_manager.dart';
import '../../blocs/game_cubit/game_cubit.dart';
import 'ui.dart';

class AdsCounterUi extends StatelessWidget {
  const AdsCounterUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final numActiveAds = state.activeAds.length;
        final text = ' $numActiveAds/$NUM_ADS_LIMIT';
        return UiBackground(
          child: Row(
            children: [
              Icon(Icons.add_moderator,
                  color: _getTextColor(numActiveAds, NUM_ADS_LIMIT)),
              Text(
                text,
                style: TextStyle(
                    color: _getTextColor(numActiveAds, NUM_ADS_LIMIT),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  Color _getTextColor(int numAds, int maxAds) {
    // number between 0-100
    final generatedAdsPercentage = numAds / maxAds * 100;
    if (generatedAdsPercentage < 25) {
      return Colors.white;
    }
    if (generatedAdsPercentage < 50) {
      return Colors.yellow;
    }
    if (generatedAdsPercentage < 75) {
      return Colors.orange;
    }
    if (generatedAdsPercentage < 90) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }
}
