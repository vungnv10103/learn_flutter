import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/play/audio_player_manager.dart';

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

  @override
  void initState() {
    _imageAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 12));
    _audioPlayerManager =
        AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
    super.initState();
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
                widget.playingSong.album,
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
                    image: widget.playingSong.image,
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
                        widget.playingSong.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.playingSong.artist,
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
          colorIcon: Colors.deepPurple,
          sizeIcon: 24,
        ),
        MediaButtonControl(
          function: () {},
          icon: Icons.skip_previous,
          colorIcon: Colors.deepPurple,
          sizeIcon: 36,
        ),
        MediaButtonControl(
          function: () {},
          icon: Icons.play_circle,
          colorIcon: Colors.deepPurple,
          sizeIcon: 64,
        ),
        MediaButtonControl(
          function: () {},
          icon: Icons.skip_next,
          colorIcon: Colors.deepPurple,
          sizeIcon: 36,
        ),
        MediaButtonControl(
          function: () {},
          icon: Icons.repeat,
          colorIcon: Colors.deepPurple,
          sizeIcon: 24,
        )
      ],
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
