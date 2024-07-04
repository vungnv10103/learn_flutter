import 'dart:async';

import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStreams = StreamController();

  void loadSongs() {
    final res = DefaultRepository();
    res.loadData().then((value) => songStreams.add(value!));
  }
}
