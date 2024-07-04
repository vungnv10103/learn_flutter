import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/play/audio_player_manager.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  final List<Song> songs;
  final Song playingSong;
  const NowPlaying({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AudioPlayerManager _audioPlayerManager;
  late Song _song;
  late int _selectedItemIndex;
  late double _currentAnimationPosition;

  @override
  void initState() {
    _song = widget.playingSong;
    _selectedItemIndex = widget.songs.indexOf(_song);
    _currentAnimationPosition = 0.0;
    _imageAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 12));
    _audioPlayerManager = AudioPlayerManager(songUrl: _song.source);
    _audioPlayerManager.init();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _song.album,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0)
                    .animate(_imageAnimationController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/music_icon.png",
                    image: _song.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/music_icon.png",
                        width: screenWidth - delta,
                        height: screenWidth - delta,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                  Column(
                    children: [
                      Text(
                        _song.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _song.artist,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline)),
                ],
              ),
              const SizedBox(height: 24),
              _progressBar(),
              const SizedBox(height: 24),
              _mediaButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MediaButtonControl(
          function: () {},
          icon: Icons.shuffle_outlined,
          colorIcon: Colors.black,
          sizeIcon: 24,
        ),
        MediaButtonControl(
          function: setPreviousSong,
          icon: Icons.skip_previous,
          colorIcon: Colors.black,
          sizeIcon: 36,
        ),
        _playerButton(),
        MediaButtonControl(
          function: setNextSong,
          icon: Icons.skip_next,
          colorIcon: Colors.black,
          sizeIcon: 36,
        ),
        MediaButtonControl(
          function: () {},
          icon: Icons.repeat,
          colorIcon: Colors.black,
          sizeIcon: 24,
        )
      ],
    );
  }

  void setNextSong() {
    _selectedItemIndex++;
    if (_selectedItemIndex == widget.songs.length) {
      _selectedItemIndex = 0;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _song = nextSong;
    });
  }

  void setPreviousSong() {
    if (_selectedItemIndex == 0) return;
    _selectedItemIndex--;
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _song = nextSong;
    });
  }

  StreamBuilder<PlayerState> _playerButton() {
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(24),
            height: 32,
            width: 32,
            child: const CircularProgressIndicator.adaptive(),
          );
        } else if (playing != true) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.play();
              _imageAnimationController.forward(
                  from: _currentAnimationPosition);
              _imageAnimationController.repeat();
            },
            icon: Icons.play_circle,
            colorIcon: Colors.black,
            sizeIcon: 64,
          );
        } else if (processingState != ProcessingState.completed) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.pause();
              _imageAnimationController.stop();
              _currentAnimationPosition = _imageAnimationController.value;
            },
            icon: Icons.pause_circle,
            colorIcon: Colors.black,
            sizeIcon: 64,
          );
        } else {
          if (processingState == ProcessingState.completed) {
            _currentAnimationPosition = 0;
            _imageAnimationController.stop();
          }
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.seek(Duration.zero);
              _imageAnimationController.forward(
                  from: _currentAnimationPosition);
              _imageAnimationController.repeat();
            },
            icon: Icons.replay,
            colorIcon: Colors.black,
            sizeIcon: 64,
          );
        }
      },
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState,
      builder: (context, snapshot) {
        final durationSate = snapshot.data;
        final progress = durationSate?.progress ?? Duration.zero;
        final buffered = durationSate?.buffered ?? Duration.zero;
        final total = durationSate?.total ?? Duration.zero;

        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffered,
          onSeek: (value) {
            _audioPlayerManager.player.seek(value);
          },
          barHeight: 5.0,
          barCapShape: BarCapShape.round,
          baseBarColor: Colors.grey.withOpacity(0.3),
          progressBarColor: Colors.red,
          bufferedBarColor: Colors.grey.withOpacity(0.3),
          thumbColor: Colors.red,
          thumbGlowColor: Colors.red.withOpacity(0.5), // when seek
          thumbRadius: 8,
        );
      },
    );
  }
}

class MediaButtonControl extends StatefulWidget {
  final void Function()? function;
  final IconData icon;
  final Color? colorIcon;
  final double? sizeIcon;

  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.colorIcon,
    required this.sizeIcon,
  });

  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.sizeIcon,
      color: widget.colorIcon ?? Theme.of(context).colorScheme.primary,
    );
  }
}
