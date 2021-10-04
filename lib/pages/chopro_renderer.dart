import "package:handmade_chopro_reader/data/master_song_list.dart";
import "package:handmade_chopro_reader/data/song_info.dart";

import "package:flutter/material.dart";

class ChordProRendererPage extends StatefulWidget {
  final SongInfo song;

  const ChordProRendererPage({required this.song, Key? key}) : super(key: key);

  @override
  State<ChordProRendererPage> createState() => _ChordProRendererPageState();
}

class _ChordProRendererPageState extends State<ChordProRendererPage> {
  var song = SongInfo(title: "", artist: "");

  @override
  void initState() {
    super.initState();
    song = widget.song;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(song.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/song_info_editor",
                arguments: song,
              ).then((newInfo) {
                if (newInfo == null) return;

                var i = MasterSongList.songList.indexWhere((s) {
                  //
                  // @Improvement: There could be a faster way to do this, but we want to keep things simple
                  // for now. Maybe use the index to the master song list as an id for the song itself?
                  //
                  var old = song;
                  var titleMatch = s.title == old.title;
                  var artistMatch = s.artist == old.artist;
                  return titleMatch && artistMatch;
                });

                MasterSongList.songList[i] = newInfo as SongInfo;
                setState(() {
                  song = newInfo;
                });
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                song.title,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Text(
                song.artist,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(song.lyrics),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
