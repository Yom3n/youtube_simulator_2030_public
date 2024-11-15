import 'package:equatable/equatable.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends Equatable {
  const YoutubeVideo(this.url);

  const YoutubeVideo.empty({this.url = ''});

  final String url;

  String get id => YoutubePlayer.convertUrlToId(url) ?? '';

  bool get isValid => id.isNotEmpty;

  bool get isInvalid => !isValid;

  @override
  List<Object?> get props => [url];

  YoutubeVideo copy() {
    return YoutubeVideo(url);
  }
}
