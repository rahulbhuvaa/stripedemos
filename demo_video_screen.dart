import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final List<VideoModel> videos = [
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl:
          'https://images.ctfassets.net/hrltx12pl8hq/3Z1N8LpxtXNQhBD5EnIg8X/975e2497dc598bb64fde390592ae1133/spring-images-min.jpg',
    ),
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl: 'https://www.referenseo.com/wp-content/uploads/2019/03/image-attractive-960x540.jpg',
    ),
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl:
          'https://images.ctfassets.net/hrltx12pl8hq/3Z1N8LpxtXNQhBD5EnIg8X/975e2497dc598bb64fde390592ae1133/spring-images-min.jpg',
    ),
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl: 'https://www.referenseo.com/wp-content/uploads/2019/03/image-attractive-960x540.jpg',
    ),
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl:
          'https://images.ctfassets.net/hrltx12pl8hq/3Z1N8LpxtXNQhBD5EnIg8X/975e2497dc598bb64fde390592ae1133/spring-images-min.jpg',
    ),
    VideoModel(
      videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailUrl: 'https://www.referenseo.com/wp-content/uploads/2019/03/image-attractive-960x540.jpg',
    ),
    // Add more videos here
  ];

  @override
  void dispose() {
    for (final video in videos) {
      video.controller?.dispose();
    }
    super.dispose();
  }

  void _initializeVideo(VideoModel video) {
    video.controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl))
      ..initialize().then((_) {
        video.controller!.setVolume(1.0);
        video.controller!.addListener(() {
          if (video.controller!.value.position >= video.controller!.value.duration) {
            video.isButtonShow = true;
          }
          setState(() {
            video.isPlaying = video.controller!.value.isPlaying;
          });
        });
        setState(() {});
      });
  }

  void togglePlayPause(VideoModel video) {
    if (video.controller != null) {
      if (video.controller!.value.isPlaying) {
        video.controller!.pause();
      } else {
        video.controller!.play();
      }
      setState(() {
        video.isPlaying = video.controller!.value.isPlaying;
      });
    }
  }

  void toggleButtonVisibility(VideoModel video) {
    // if (video.controller != null && video.controller!.value.isPlaying) {
      video.isButtonShow = !video.isButtonShow;
      if (video.isPlaying && video.isButtonShow) {
        video.buttonTimer = Timer(const Duration(seconds: 2), () {
          setState(() {
            video.isButtonShow = false;
          });
        });
      }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Lists'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: video.thumbnailUrl,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      if (!video.isPlaying && !video.isButtonShow)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    if (video.controller == null) {
                      _initializeVideo(video);
                    }
                    // video.isButtonShow = true;
                    // Future.delayed(const Duration(seconds: 2), () {
                    //   setState(() {
                    //     video.isButtonShow = false;
                    //   });
                    // });
                    toggleButtonVisibility(video);
                    togglePlayPause(video);
                  },
                ),
              ),
              if (video.controller != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            toggleButtonVisibility(video);
                          },
                          child: VideoPlayer(video.controller!),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePlayPause(video);
                          },
                          child: Center(
                            child: Visibility(
                              visible: video.isButtonShow,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  video.isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class VideoModel {
  final String videoUrl;
  final String thumbnailUrl;
  VideoPlayerController? controller;
  bool isPlaying;
  bool isButtonShow;
  Timer? buttonTimer;

  VideoModel({
    required this.videoUrl,
    required this.thumbnailUrl,
    this.controller,
    this.isPlaying = false,
    this.isButtonShow = false,
  });
}
