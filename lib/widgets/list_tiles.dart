import "package:handmade_chopro_reader/data/song_info.dart";
import "package:flutter/material.dart";

class SongTile extends StatelessWidget {
  final SongInfo song;
  final bool showArtist, showCategories;

  const SongTile({
    required this.song,
    this.showArtist = true,
    this.showCategories = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = Theme.of(context).textTheme;
    var color = Theme.of(context).colorScheme;
    var w = MediaQuery.of(context).size.width;

    return Container(
      color: color.surface,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // @Improvement: There might be a way to make it so that we don't have to make
          // SizedBoxes for every widget in the Column, but rather have 1 "container" that
          // is sized appropriately and that the other widgets just fill in.
          //
          SizedBox(
            width: w,
            child: Text(song.title, style: text.headline6),
          ),
          SizedBox(
            width: w,
            child: !showArtist ? null : Text(song.artist, style: text.subtitle1),
          ),
          SizedBox(
            width: w,
            child: !showCategories ? null : Text(song.categories.join(", "), style: text.subtitle2),
          ),
        ],
      ),
    );
  }
}

class ArtistTile extends StatelessWidget {
  final ArtistInfo artist;

  const ArtistTile({required this.artist, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = artist.songCount;
    return ListTile(
      title: Text(artist.name),
      subtitle: Text("$count song${count != 1 ? "s" : ""}"),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryInfo category;

  const CategoryTile({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = category.songCount;
    return ListTile(
      title: Text(category.name),
      subtitle: Text("$count song${count != 1 ? "s" : ""}"),
    );
  }
}
