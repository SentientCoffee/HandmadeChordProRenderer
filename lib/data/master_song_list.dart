import "package:handmade_chopro_reader/data/song_info.dart";

class MasterSongList {
  static var songList = <SongInfo>[];

  //
  // @Improvement: Cache the categories so that we do not spend
  // time recalculating the list every time we want to access it.
  //
  static List<CategoryInfo> get categoryList {
    var uniqueCategories = <String>[];
    for (var s in songList) {
      for (var c in s.categories) {
        if (uniqueCategories.contains(c)) continue;
        uniqueCategories.add(c);
      }
    }

    var categories = <CategoryInfo>[];
    for (var c in uniqueCategories) {
      var count = songList.where((s) => s.categories.contains(c)).length;
      categories.add(CategoryInfo(name: c, songCount: count));
    }

    categories.sort((c1, c2) => c1.name.compareTo(c2.name));
    return categories;
  }

  static build() {
    // @Temporary: DON'T KEEP THIS
    var finneas = SongInfo(title: "Let's Fall In Love For The Night", artist: "FINNEAS");
    finneas.categories = ["Pop", "Modern", "Random"];
    finneas.lyrics = """
{c:Capo 5}

{soc}
Let's fall in [Dm]love for the night and for[G]get in the morning  [Am7]
Play me a [Dm]song that you like, you can [G]bet I'll know every [C]line
I'm the [Dm]boy that your boy hoped that [G]you would avoid
Don't [C]waste your eyes on jealous guys, [Am7]fuck that noise
[Dm]I know better [G/]than to [G7/]call you [Cmaj7/]mine
{eoc}

You need a pick me [Dm]up? [G]I'll be there in twenty-[Am7]five
I like to push my [Dm]luck, [G]so take my hand, let's [C]take a drive
[E7]I've been living in the [Dm]future, [G]hoping I might see you [C]sooner  [Am7]
I want [Dm]you riding shotgun, I knew when I got one [G]right  [G7]

{soc}
Let's fall in [Dm]love for the night and for[G]get in the morning  [Am7]
Play me a [Dm]song that you like, you can [G]bet I'll know every [C]line
I'm the [Dm]boy that your boy hoped that [G]you would avoid
Don't [C]waste your eyes on jealous guys, [Am7]fuck that noise
[Dm]I know better [G/]than to [G7/]call you [Cmaj7/]mine
{eoc}

I love it [Dm]when you talk that nerdy shit, [G]we're in our [Am7]twenties talking thirties shit
We're making [Dm]money but we're saving it, '[G]cause talking shit is [C]cheap and we talk a lot of [E7]it
You won't [Dm]stay with me, I [G]know
But you can have your [C]way with me [C/B]till you [Am7]go
And be[Dm]fore your kisses turn into bruises, I'm a [G]warning  [G7]

{soc}
Let's fall in [Dm/]love for the night and for[G/]get in the morning  [Am7]
Play me a [Dm/]song that you like, you can [G/]bet I'll know every [C]line  [E7/]
'Cause I'm the [Dm/]boy that your boy hoped that [G/]you would avoid
Don't [Cmaj7/]waste your eyes on jealous guys, [Am7//]fuck that [A7/]noise
[Dm]I know bette[G]r, [Dm]I know bette[G]r, [Dm/]I know better than to [G/]ever [G7/]call you mine  [Cmaj7]
{eoc}
""";

    songList = [
      SongInfo(title: "SongF", artist: "ArtistA"),
      SongInfo(title: "SongC", artist: "ArtistB"),
      SongInfo(title: "SongE", artist: "ArtistA"),
      SongInfo(title: "SongA", artist: "ArtistA"),
      SongInfo(title: "SongG", artist: "ArtistC"),
      SongInfo(title: "SongB", artist: "ArtistA"),
      SongInfo(title: "SongI", artist: "ArtistF"),
      finneas,
      SongInfo(title: "SongH", artist: "ArtistC"),
      SongInfo(title: "SongD", artist: "ArtistB"),
      SongInfo(title: "SongJ", artist: "ArtistE"),
    ];
  }
}
