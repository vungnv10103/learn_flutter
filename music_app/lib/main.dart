import 'package:flutter/material.dart';
import 'package:music_app/data/repository/repository.dart';
import 'package:music_app/ui/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var respository = DefaultRepository();
  var songs = await respository.loadData();
  if (songs != null) {
    debugPrint('${songs.length} - $songs');
    for (var song in songs) {
      debugPrint(song.title);
    }
  } else {
    debugPrint("hello");
  }

  runApp(const MyMusicApp());
}
