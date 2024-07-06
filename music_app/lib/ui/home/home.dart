import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/view_model.dart';
import 'package:music_app/ui/play/audio_player_manager.dart';
import 'package:music_app/ui/play/now_playing.dart';
import 'package:music_app/ui/settings/settings.dart';
import 'package:music_app/ui/user/user.dart';

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MusicPage(),
    );
  }
}

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  int currentPage = 0;
  final List<Widget> pages = const [
    HomePage(),
    DiscoveryPage(),
    UserPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        // selectedFontSize: 0,
        // unselectedFontSize: 0,
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        selectedIconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).primaryColor),
        unselectedIconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.grey.withOpacity(0.8),
            ),
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              label: "Discovery",
              tooltip: "Discovery"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            tooltip: "Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            tooltip: "Settings",
          )
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.songStreams.close();
    AudioPlayerManager().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getBody(),
    );
  }

  Widget getBody() {
    if (songs.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return getListView();
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSession(
      parent: this,
      song: songs[index],
    );
  }

  void observeData() {
    _viewModel.songStreams.stream.listen(
      (songList) {
        setState(() {
          songs.addAll(songList);
        });
      },
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Modal"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"))
              ],
            ),
          ),
        );
      },
    );
  }

  void navigate(Song song) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return NowPlaying(songs: songs, playingSong: song);
      },
    ));
  }
}

class _SongItemSession extends StatelessWidget {
  final _HomePageState parent;
  final Song song;

  const _SongItemSession({required this.parent, required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 8, left: 24),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage.assetNetwork(
          placeholder: "assets/images/music_icon.png",
          width: 48,
          height: 48,
          image: song.image,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/music_icon.png",
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        onPressed: () {
          parent.showBottomSheet();
        },
        icon: const Icon(Icons.more_vert),
      ),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}
