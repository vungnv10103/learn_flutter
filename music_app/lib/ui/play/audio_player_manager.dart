import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  String songUrl;
  final player = AudioPlayer();
  Stream<DurationState>? durationState;

  AudioPlayerManager({required this.songUrl});

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, playBackEvent) {
        return DurationState(
          progress: position,
          buffered: playBackEvent.bufferedPosition,
          total: playBackEvent.duration,
        );
      },
    );
    player.setUrl(songUrl);
  }

  void updateSongUrl(String url) {
    songUrl = url;
    init();
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration? total;

  DurationState({required this.progress, required this.buffered, this.total});
}
