// ignore_for_file: file_names, use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables, unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vidget/Screens/constant/colors.dart';
import 'package:vidget/Screens/constant/constant.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final VideoId videoId;

  const PlayerScreen(this.videoId, {Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final String mediaUrl = ""; // Add the media URL herebool downloading = false;
  double downloadProgress = 0.0;

  bool downloading = false;

  int selectedOption = 0;
  void downloadMedia(String mediaType, int selectedOption) async {
    // Check for and request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        // Permission denied, show an error message or handle it appropriately
        print('Storage permission denied');
        return;
      }
    }

    setState(() {
      downloading = true;
    });

    try {
      final youtubeExplode = YoutubeExplode();
      var manifest =
          await youtubeExplode.videos.streamsClient.getManifest(widget.videoId);

      StreamInfo? videoStream;
      StreamInfo? audioStream;

      if (mediaType == 'audio') {
        // Find the audio stream with the desired codec (e.g., 'mp4a')
        audioStream = manifest.audioOnly.firstWhereOrNull(
            (audioStream) => audioStream.audioCodec == 'mp4a');

        // If the desired audio codec is not found, choose the best available audio stream
        audioStream ??= manifest.audioOnly.reduce((curr, next) =>
            curr.bitrate.compareTo(next.bitrate) > 0 ? curr : next);
      } else if (mediaType == 'video') {
        // Find the video stream with the desired resolution
        switch (selectedOption) {
          case 1:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '144p');
            break;
          case 2:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '240p');
            break;
          case 3:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '360p');
            break;
          case 4:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '480p');
            break;
          case 5:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '720p');
            break;
          case 6:
            videoStream = manifest.videoOnly.firstWhereOrNull(
                (videoStream) => videoStream.videoResolution == '1080p');
            break;
          // Add cases for other resolutions...
        }

        // If the selected resolution is not found, choose the best available resolution
        videoStream ??= manifest.videoOnly.reduce((curr, next) =>
            curr.videoResolution.compareTo(next.videoResolution) > 0
                ? curr
                : next);

        // Find the corresponding audio stream for the video stream
        audioStream = manifest.audioOnly.firstWhereOrNull((audioStream) =>
            audioStream.audioCodec == 'mp4a' &&
            audioStream.bitrate == videoStream?.bitrate);

        // If no matching audio stream is found, choose the best available audio stream
        audioStream ??= manifest.audioOnly.reduce((curr, next) =>
            curr.bitrate.compareTo(next.bitrate) > 0 ? curr : next);
      } else {
        throw ArgumentError('Invalid media type: $mediaType');
      }

      if (videoStream == null || audioStream == null) {
        print('Stream information not found');
        throw ArgumentError('Stream information not found');
      }

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Failed to get external storage directory');
        return;
      }

      // Create a directory for your app if it doesn't exist
      final appDirectory = Directory('${directory.path}/YourAppName');
      if (!appDirectory.existsSync()) {
        appDirectory.createSync();
      }

      final videoFilePath =
          '${appDirectory.path}/${widget.videoId.value}_video.${videoStream.container.name}';
      final audioFilePath =
          '${appDirectory.path}/${widget.videoId.value}_audio.${audioStream.container.name}';

      final dio = Dio();
      await Future.wait([
        dio.download(videoStream.url.toString(), videoFilePath),
        dio.download(audioStream.url.toString(), audioFilePath),
      ]);

      // Combine video and audio using flutter_ffmpeg
      final outputFilePath =
          '${appDirectory.path}/${widget.videoId.value}_combined.mp4';

      final flutterFFmpeg = FlutterFFmpeg();
      await flutterFFmpeg.execute(
          '-i $videoFilePath -i $audioFilePath -c:v copy -c:a aac $outputFilePath');

      // Delete separate video and audio files if needed
      File(videoFilePath).deleteSync();
      File(audioFilePath).deleteSync();

      setState(() {
        downloading = false;
        downloadProgress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download complete!'),
        ),
      );

      // Optionally, you can use FlutterFFmpeg to convert the downloaded video to other formats.
      // Add your FFmpeg conversion code here if needed.
    } catch (e) {
      setState(() {
        downloading = false;
        downloadProgress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed. Please try again. Error: $e'),
        ),
      );

      print('Error: $e');
    }
  }

  void showDownloadOptions() {
    int? selectedOption;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        EvaIcons.musicOutline,
                        color: primaryColor1,
                      ),
                      Text(
                        'Music',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor1),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor1,
                        value: 1,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('128K'),
                      Radio(
                        activeColor: primaryColor1,
                        value: 2,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('48K'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor1,
                        value: 3,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('256K'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.videoOutline,
                        color: primaryColor1,
                      ),
                      Text(
                        'Video',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor1),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor1,
                        value: 4,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('144P'),
                      Radio(
                        activeColor: primaryColor1,
                        value: 5,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('240P'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor1,
                        value: 6,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('360P'),
                      Radio(
                        activeColor: primaryColor1,
                        value: 7,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('480P'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor1,
                        value: 8,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('720P HD'),
                      Radio(
                        activeColor: primaryColor1,
                        value: 9,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as int;
                          });
                        },
                      ),
                      const Text('1080P HD'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (selectedOption != null) {
                        if (selectedOption! >= 1 && selectedOption! <= 3) {
                          // Audio is selected
                          downloadMedia('audio', selectedOption!);
                        } else if (selectedOption! >= 4 &&
                            selectedOption! <= 9) {
                          // Video is selected
                          downloadMedia('video', selectedOption!);
                        } else {
                          // Handle unexpected values
                        }
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an option.'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(colors: [
                          primaryColor1,
                          primaryColor2,
                        ]),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.download,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Download",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            primaryColor1,
            primaryColor2,
          ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    "VidGet",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: widget.videoId.value,
                flags: const YoutubePlayerFlags(autoPlay: true),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        channelName,
                        style: const TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDownloadOptions();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: downloading
                              ? Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment
                                          .center, // Center the children within the Stack
                                      children: [
                                        Image.asset(
                                          "assets/icons/download1.png",
                                          scale: 10,
                                          width: 26,
                                          color: primaryColor2,
                                        ),
                                        Positioned(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              color: primaryColor2,
                                              strokeWidth: 2,
                                              value: downloadProgress,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Text(
                                        '${(downloadProgress * 100).toStringAsFixed(2)}%',
                                        style: TextStyle(
                                            color: primaryColor2, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                )
                              : Image.asset(
                                  "assets/icons/download1.png",
                                  scale: 10,
                                  width: 30,
                                  color: primaryColor2,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
