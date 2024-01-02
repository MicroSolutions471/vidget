// ignore_for_file: file_names, deprecated_member_use, duplicate_ignore, library_private_types_in_public_api

import 'package:flutter/material.dart';

// Use a prefix for the import
import 'package:vidget/Screens/Player.dart';
import 'package:vidget/Screens/constant/constant.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// Importing v1.dart with a prefix

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final YoutubeExplode _ytExplode = YoutubeExplode();
  List<Video> _searchResults = [];
  bool _loading = false;

  Future<void> _searchVideos() async {
    setState(() {
      _loading = true; // Set loading to true when starting the search
    });

    try {
      var query = _searchController.text;
      var searchResults = await _ytExplode.search.getVideos(query);
      setState(() {
        _searchResults = searchResults.toList();
      });
    } finally {
      setState(() {
        _loading = false; // Set loading to false when search is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search for videos...',
            ),
            onSubmitted: (value) {
              _searchVideos();
            },
          ),
          if (_loading)
            const LinearProgressIndicator(
              color: Colors.orange,
            ) // Show loading indicator if loading is true
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var video = _searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      videoTitle = video.title;
                      channelName = video.author;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(video.id),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ListTile(
                          leading: Image(
                            image: NetworkImage(video.thumbnails.highResUrl),
                          ),
                          title: Text(
                            video.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(video.author),
                        ),
                        Positioned(
                          child: Text(
                            '${video.duration!.inMinutes}:${(video.duration!.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
