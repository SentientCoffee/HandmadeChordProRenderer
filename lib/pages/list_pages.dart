import "package:handmade_chopro_reader/data/master_song_list.dart";
import "package:handmade_chopro_reader/data/song_info.dart";
import "package:handmade_chopro_reader/widgets/list_tiles.dart";

import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";

enum PageType {
  songs,
  artists,
  categories,
}

class SongListPage extends StatefulWidget {
  final List<SongInfo> songs;
  final bool showArtist, showCategories;

  const SongListPage({
    required this.songs,
    this.showArtist = true,
    this.showCategories = true,
    Key? key,
  }) : super(key: key);

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  @override
  Widget build(BuildContext context) {
    widget.songs.sort((s1, s2) => s1.title.compareTo(s2.title));
    var count = widget.songs.length;

    return ListView.separated(
      itemCount: count + 1,
      itemBuilder: (context, index) {
        if (index == count) {
          return Center(
            heightFactor: 2.0,
            child: Text(
              "$count song${count != 1 ? "s" : ""}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }

        return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              icon: Icons.delete,
              color: Colors.red,
              onTap: () {
                //
                // @Improvement: There could be a faster way to do this, but we want to keep things simple
                // for now. Maybe use the index to the master song list as an id for the song itself?
                //
                // @Note: We are not caching the MasterSongList.songList call here because otherwise
                // we would only be modifying the local cached variable instead of the actual master
                // song list like we want.
                //
                var i = MasterSongList.songList.indexWhere((s) => s.title == widget.songs[index].title);
                var r = MasterSongList.songList.removeAt(i);
                setState(() {
                  widget.songs.removeAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Deleted ${r.title} from song list"),
                    duration: const Duration(seconds: 2),
                  ));
                });
              },
            ),
            IconSlideAction(
              icon: Icons.edit,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/song_info_editor",
                  arguments: widget.songs[index],
                ).then((newInfo) {
                  if (newInfo == null) return;

                  var i = MasterSongList.songList.indexWhere((s) {
                    //
                    // @Improvement: There could be a faster way to do this, but we want to keep things simple
                    // for now. Maybe use the index to the master song list as an id for the song itself?
                    //
                    var old = widget.songs[index];
                    var titleMatch = s.title == old.title;
                    var artistMatch = s.artist == old.artist;
                    return titleMatch && artistMatch;
                  });

                  setState(() {
                    MasterSongList.songList[i] = newInfo as SongInfo;
                  });
                });
              },
            ),
          ],
          child: GestureDetector(
            child: SongTile(
              song: widget.songs[index],
              showArtist: widget.showArtist,
              showCategories: widget.showCategories,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                "/chopro_renderer",
                arguments: widget.songs[index],
              ).then((value) => setState(() {}));
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey,
        );
      },
    );
  }
}

class ArtistListPage extends StatefulWidget {
  final List<SongInfo> songs;

  const ArtistListPage({required this.songs, Key? key}) : super(key: key);

  @override
  State<ArtistListPage> createState() => _ArtistListPageState();
}

class _ArtistListPageState extends State<ArtistListPage> {
  @override
  Widget build(BuildContext context) {
    var uniqueArtists = <String>[];
    for (var s in widget.songs) {
      if (uniqueArtists.contains(s.artist)) continue;
      uniqueArtists.add(s.artist);
    }

    var artists = <ArtistInfo>[];
    for (var a in uniqueArtists) {
      var c = widget.songs.where((s) => s.artist == a).length;
      artists.add(ArtistInfo(name: a, songCount: c));
    }

    artists.sort((a1, a2) => a1.name.compareTo(a2.name));
    var count = artists.length;

    return ListView.separated(
      itemCount: count + 1,
      itemBuilder: (context, index) {
        if (index == count) {
          return Center(
            heightFactor: 2.0,
            child: Text(
              "$count artist${count != 1 ? "s" : ""}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }

        var a = artists[index];
        return GestureDetector(
          child: ArtistTile(artist: a),
          onTap: () {
            Navigator.pushNamed(
              context,
              "/artist_scaffold",
              arguments: widget.songs.where((s) => s.artist == a.name).toList(),
            ).then((value) => setState(() {}));
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey,
        );
      },
    );
  }
}

class CategoryListPage extends StatefulWidget {
  final List<SongInfo> songs;

  const CategoryListPage({required this.songs, Key? key}) : super(key: key);

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    var categories = MasterSongList.categoryList;
    var count = categories.length;

    return ListView.separated(
      itemCount: count + 1,
      itemBuilder: (context, index) {
        if (index == count) {
          return Center(
            heightFactor: 2.0,
            child: Text(
              "$count categor${count != 1 ? "ies" : "y"}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }

        var c = categories[index];
        return GestureDetector(
          child: CategoryTile(category: c),
          onTap: () {
            Navigator.pushNamed(
              context,
              "/category_scaffold",
              arguments: <dynamic>[c.name, widget.songs.where((s) => s.categories.contains(c.name)).toList()],
            ).then((value) => setState(() {}));
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey,
        );
      },
    );
  }
}
