import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuickVideoDialog extends StatefulWidget {
  final String videoUrl;

  const QuickVideoDialog({super.key, required this.videoUrl});

  @override
  State<QuickVideoDialog> createState() => _QuickVideoDialogState();
}

class _QuickVideoDialogState extends State<QuickVideoDialog> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  YoutubePlayerController? _youtubeController;

  bool _isYoutube = false;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

      if (videoId != null) {
        _isYoutube = true;
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
          ),
        );
        setState(() {
          _isInitialized = true;
        });
      } else {
        _isYoutube = false;
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          errorBuilder: (context, errorMessage) {
            return const Center(
              child: Text("Error al reproducir video", style: TextStyle(color: Colors.white)),
            );
          },
        );
        
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error inicializando video: $e");
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 400),
        child: _content(),
      ),
    );
  }

  Widget _content() {
    if (_hasError) {
      return const Center(child: Text("No se pudo cargar el video", style: TextStyle(color: Colors.white)));
    }

    if (!_isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isYoutube) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blue,
          progressColors: const ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      );
    }
  }
}