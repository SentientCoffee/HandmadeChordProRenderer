class SongInfo {
  String title;
  String artist;
  List<String> categories;

  String lyrics = "[Placeholder]"; // @Temp: This shouldn't have any data, but it does to make sure rendering works

  SongInfo({
    required this.title,
    required this.artist,
    this.categories = const ["Test1", "Test2"], // @Temp: This shouldn't have any data, but it does to make sure rendering works
  });
}

class ArtistInfo {
  String name;
  int songCount;

  ArtistInfo({required this.name, required this.songCount});
}

class CategoryInfo {
  String name;
  int songCount;

  CategoryInfo({required this.name, required this.songCount});
}
