import 'package:handmade_chopro_reader/data/master_song_list.dart';
import "package:handmade_chopro_reader/data/song_info.dart";
import "package:flutter/material.dart";

class SongInfoEditorPage extends StatefulWidget {
  //
  // @Note: If song info is null, the fields in the info editor will not be filled
  //
  final SongInfo? song;

  const SongInfoEditorPage({required this.song, Key? key}) : super(key: key);

  @override
  _SongInfoEditorPageState createState() => _SongInfoEditorPageState();
}

class _SongInfoEditorPageState extends State<SongInfoEditorPage> {
  final formKey = GlobalKey<FormState>();
  final categoryInputKey = GlobalKey<FormFieldState>();

  var songTitle = "", songArtist = "", newCategory = "", songLyrics = "";

  var songCategories = <String>[];
  var availableCategories = <String>[];
  var isCheckingCategorySave = false;

  String? validateField(String? text) {
    if (text == null || text.isEmpty) return "Field cannot be empty.";
    return null;
  }

  @override
  void initState() {
    super.initState();
    availableCategories.addAll(MasterSongList.categoryList.map((c) => c.name));

    if (widget.song != null) {
      var s = widget.song!;
      songTitle = s.title;
      songArtist = s.artist;
      songLyrics = s.lyrics;
      //
      // @Note: using songCategories = s.categories here gave it
      // a reference to the list, which is unmodifiable. This call to
      // addAll() makes sure that the list is copied rather than modified
      // directly.
      //
      songCategories.addAll(s.categories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.song == null ? "Add" : "Edit"} song"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: songTitle,
                  decoration: const InputDecoration(
                    labelText: "Song title",
                  ),
                  validator: validateField,
                  onChanged: (text) {
                    songTitle = text;
                  },
                ),
                TextFormField(
                  initialValue: songArtist,
                  decoration: const InputDecoration(
                    labelText: "Song artist",
                  ),
                  validator: validateField,
                  onChanged: (text) {
                    songArtist = text;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: () {
                    var widgets = <Widget>[];
                    widgets.add(const Text("Song categories"));

                    for (var i = 0; i < availableCategories.length; ++i) {
                      var c = availableCategories[i];
                      widgets.add(Row(
                        children: [
                          Checkbox(
                            value: songCategories.contains(c),
                            onChanged: (value) {
                              if (value == null) return; // @Note: Doing an explicit null check to avoid runtime exceptions with ! operator
                              setState(() {
                                if (value) {
                                  songCategories.add(c);
                                } else {
                                  songCategories.remove(c);
                                }
                              });
                            },
                          ),
                          Text(c),
                        ],
                      ));
                    }

                    widgets.add(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(text: newCategory),
                            key: categoryInputKey,
                            decoration: const InputDecoration(
                              labelText: "Add new category",
                            ),
                            onChanged: (text) {
                              newCategory = text;
                            },
                            validator: (text) {
                              if (!isCheckingCategorySave) return null;
                              if (text == null || text.isEmpty) return "No category made: field is empty.";
                              return null;
                            },
                          ),
                        ),
                        TextButton(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            color: Theme.of(context).colorScheme.primary,
                            child: Text(
                              "Save",
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          onPressed: () {
                            // @Hack but I can't think of a better way to do this at the moment...
                            isCheckingCategorySave = true;
                            var success = categoryInputKey.currentState!.validate();
                            isCheckingCategorySave = false;

                            if (success) {
                              setState(() {
                                if (!availableCategories.contains(newCategory)) {
                                  availableCategories.add(newCategory);
                                }
                                songCategories.add(newCategory);
                                newCategory = "";
                              });
                            }
                          },
                        ),
                      ],
                    ));

                    return widgets;
                  }(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                TextFormField(
                  controller: TextEditingController(text: songLyrics),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: "Lyrics",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateField,
                  onChanged: (text) {
                    songLyrics = text;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          var success = formKey.currentState!.validate();
          if (success) {
            var newInfo = SongInfo(title: songTitle, artist: songArtist, categories: songCategories);
            newInfo.lyrics = songLyrics;
            print("Saving new info: ${newInfo.title} by ${newInfo.artist} (Categories: ${newInfo.categories})");
            Navigator.pop(context, newInfo);
          }
        },
      ),
    );
  }
}
