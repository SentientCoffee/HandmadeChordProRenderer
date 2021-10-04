import "package:handmade_chopro_reader/data/master_song_list.dart";
import "package:handmade_chopro_reader/data/song_info.dart";

import "package:handmade_chopro_reader/pages/chopro_renderer.dart";
import "package:handmade_chopro_reader/pages/main_scaffold.dart";
import "package:handmade_chopro_reader/pages/song_info_editor.dart";

import "package:flutter/material.dart";

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MasterSongList.build(); // @Temp: should not need to be here, but is for debugging purposes

    return MaterialApp(
      title: "Handmade ChordPro Reader",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainScaffold(title: "Handmade ChordPro Reader"),
      debugShowCheckedModeBanner: false,
      routes: {
        "/main_scaffold": (context) => const MainScaffold(title: "Handmade ChordPro Reader"),
        "/artist_scaffold": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List<SongInfo>;
          return SubScaffold(title: args[0].artist, songList: args, showArtist: false);
        },
        "/category_scaffold": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
          var category = args[0] as String;
          var songs = args[1] as List<SongInfo>;
          return SubScaffold(title: category, songList: songs, showCategories: false);
        },
        "/chopro_renderer": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as SongInfo;
          return ChordProRendererPage(song: args);
        },
        "/song_info_editor": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as SongInfo?;
          return SongInfoEditorPage(song: args);
        },
      },
    );
  }
}
