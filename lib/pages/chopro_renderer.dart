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
        child: LayoutBuilder(
          builder: (ctx, constraints) => SizedBox(
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  song.title,
                  style: Theme.of(ctx).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                Text(
                  song.artist,
                  style: Theme.of(ctx).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _preProcessLyrics(song.lyrics, ctx, constraints),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _preProcessLyrics(String lyrics, BuildContext context, BoxConstraints constraints) {
    const commentSequence = "{c:";
    const socSequence = "{soc}";
    const eocSequence = "{eoc}";

    const defaultTextStyle = TextStyle(fontFamily: "FiraCode", fontSize: 12);

    //
    // @Robustness: Improve this regex
    // Current only supports (brackets mean optional):
    // - A[m][7]
    //
    var chordRegex = RegExp(r"\[[A-G]m?7?\S*\]");

    var widgets = <Widget>[];
    var surroundedWidgets = <Widget>[];
    var inChorus = false;

    var maxSize = Size(constraints.maxWidth, constraints.maxHeight);

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.from(surroundedWidgets),
              ),
            ),
          ],
        ));
        surroundedWidgets.clear();
      } else {
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

        _getTextSize(Text text) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(text: text.data, style: text.style),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();
          return textPainter.size;
        }

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

        var chords1 = spacedChords;
        var line1 = line.trim();
        var chords2 = "", line2 = "";

        var c1 = _makeChords(chords1);
        var l1 = _makeLyrics(line1);
        Text? c2, l2;

        while (maxSize.width - _getTextSize(l1).width <= 10.0) {
          var lastSpace = line1.lastIndexOf(' ');
          line2 = line2.replaceRange(0, 0, line1.substring(lastSpace)); // @Note: Basically a string.insert(0, string) but dart doesn't have that for some reason
          line1 = line1.substring(0, lastSpace);
          l1 = _makeLyrics(line1);
          l2 = _makeLyrics(line2.trim());
        }

        var i = 0;
        if (l2 != null) {
          while (_getTextSize(c1).width > _getTextSize(l1).width) {
            chords2 = chords2.replaceRange(0, 0, chords1.substring(chords1.length - 2));
            chords1 = chords1.substring(0, chords1.length - 2);
            c1 = _makeChords(chords1);
            c2 = _makeChords(chords2);

            if (++i >= 50) break;
          }

          if (c2 != null && c2.data![0] == ' ') {
            // @Note: Remove leading space because it got replaced in text wrapping
            c2 = _makeChords(c2.data!.substring(1));
          } else {
            // @Note: Add empty line to maintain consistent spacing with the lyrics
            c2 = _makeChords("");
          }
        } else {
          while (maxSize.width - _getTextSize(c1).width <= 0.0) {
            var lastChord = chords1.trimRight().lastIndexOf(' ') + 1;
            chords1 = chords1.substring(0, lastChord - 1) + chords1.substring(lastChord);
            c1 = _makeChords(chords1);

            if (++i >= 50) break;
          }
        }

        var w = [c1, l1];
        if (c2 != null) w.add(c2);
        if (l2 != null) w.add(l2);

        if (inChorus) {
          surroundedWidgets.addAll(w);
        } else {
          widgets.addAll(w);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
