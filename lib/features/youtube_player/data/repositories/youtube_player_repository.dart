import 'package:shared_preferences/shared_preferences.dart';

import '../models/youtube_video.dart';

class YoutubePlayerRepository {
  YoutubePlayerRepository(this.sharedPreferences);

  static const String DEFAULT_SONG_URL = 'https://youtu.be/Ny4uqUVs3_Y';

  static const String SONG_ID_KEY = 'YOUTUBE_SONG_ID';

  final SharedPreferences sharedPreferences;

  YoutubeVideo getYoutubeVideo() {
    String? id = sharedPreferences.getString(SONG_ID_KEY);
    id ??= DEFAULT_SONG_URL;
    return YoutubeVideo(id);
  }

  Future<bool> setVideo(YoutubeVideo newVideo) async {
    assert(newVideo.id.isNotEmpty);
    return sharedPreferences.setString(SONG_ID_KEY, newVideo.url);
  }

  Future<bool> resetToDefaultVideoId() async {
    return sharedPreferences.setString(SONG_ID_KEY, DEFAULT_SONG_URL);
  }
}
