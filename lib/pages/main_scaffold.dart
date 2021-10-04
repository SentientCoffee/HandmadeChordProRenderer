import "package:handmade_chopro_reader/data/master_song_list.dart";
import "package:handmade_chopro_reader/data/song_info.dart";
import "package:handmade_chopro_reader/pages/list_pages.dart";

import "package:flutter/material.dart";

class MainScaffold extends StatefulWidget {
  final String title;

  const MainScaffold({required this.title, Key? key}) : super(key: key);

  static _MainScaffoldState of(BuildContext ctx) => ctx.findRootAncestorStateOfType<_MainScaffoldState>()!;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  var pageIndex = PageType.songs;

  @override
  Widget build(BuildContext context) {
    var songs = MasterSongList.songList;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/song_info_editor",
                arguments: null,
              ).then((newInfo) {
                if (newInfo == null) return;

                setState(() {
                  MasterSongList.songList.add(newInfo as SongInfo);
                });
              });
            },
          ),
        ],
      ),
      body: () {
        switch (pageIndex) {
          case PageType.songs:
            return SongListPage(songs: songs);
          case PageType.artists:
            return ArtistListPage(songs: songs);
          case PageType.categories:
            return CategoryListPage(songs: songs);
        }
      }(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          currentIndex: pageIndex.index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_music),
              label: "Songs",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_external_on),
              label: "Artists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              label: "Categories",
            ),
          ],
          onTap: (index) {
            setState(() {
              pageIndex = PageType.values[index];
            });
          }),
    );
  }
}

class SubScaffold extends StatelessWidget {
  final String title;
  final List<SongInfo> songList;
  final bool showArtist, showCategories;

  const SubScaffold({
    required this.title,
    required this.songList,
    this.showArtist = true,
    this.showCategories = true,
    Key? key,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SongListPage(
        songs: songList,
        showArtist: showArtist,
        showCategories: showCategories,
      ),
    );
  }
}
