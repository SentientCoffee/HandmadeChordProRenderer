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
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _preProcessLyrics(song.lyrics),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _preProcessLyrics(String lyrics) {
    const commentSequence = "{c:";
    const socSequence = "{soc}";
    const eocSequence = "{eoc}";
    //
    // @Robustness: Improve this regex
    // Current only supports (brackets mean optional):
    // - A[m][7]
    //
    var chordRegex = RegExp(r"\[[A-G]m?7?\S*\]");

    var defaultTextStyle = const TextStyle(fontFamily: "FiraCode", fontSize: 12);
    var widgets = <Widget>[];

    var inChorus = false;
    var surroundedWidgets = <Widget>[];

    var lines = lyrics.split('\n');
    for (var line in lines) {
      if (line.startsWith(commentSequence)) {
        // @Robustness: maybe check in the middle of lines?
        var endBracket = line.indexOf('}');
        line = line.substring(commentSequence.length, endBracket);
        widgets.add(Text(
          line,
          style: defaultTextStyle.merge(const TextStyle(color: Colors.blue)),
        ));
      } else if (line.startsWith(socSequence)) {
        // @Robustness: maybe check in the middle of lines?
        inChorus = true;
      } else if (line.startsWith(eocSequence)) {
        // @Robustness: maybe check in the middle of lines?
        inChorus = false;
        widgets.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chorus",
              style: defaultTextStyle.merge(TextStyle(color: Colors.blue[700])),
            ),
            Container(
              color: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.from(surroundedWidgets),
              ),
            ),
          ],
        ));
        surroundedWidgets.clear();
      } else {
        var chords = <int, String>{};
        while (line.contains(chordRegex)) {
          var chordIndex = line.indexOf(chordRegex, chords.keys.isEmpty ? 0 : chords.keys.last + 1);
          var chordString = line.substring(chordIndex + 1, line.indexOf(']', chordIndex + 1));
          chords.addAll(<int, String>{
            chordIndex: chordString,
          });
          line = line.replaceFirst(chordRegex, '');
        }

        var spacedChords = "";

        for (var i in chords.keys) {
          var c = chords[i]!;
          spacedChords = spacedChords.padRight(i, ' ');
          spacedChords += c;
        }

        _makeChords(String text) => Text(
              text,
              style: defaultTextStyle.merge(const TextStyle(color: Colors.red)),
              textWidthBasis: TextWidthBasis.parent,
              softWrap: false,
            );

        _makeLyrics(String text) => Text(
              text,
              style: defaultTextStyle,
              textWidthBasis: TextWidthBasis.parent,
              softWrap: false,
            );

        var c = _makeChords(spacedChords);
        var l = _makeLyrics(line.trim());
        if (inChorus) {
          surroundedWidgets.addAll([c, l]);
        } else {
          widgets.addAll([c, l]);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
