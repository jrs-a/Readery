import 'package:readery/features/novels/chapter.dart';
import 'package:readery/features/novels/genre.dart';

class Novel {
  final String altTitle;
  final String author;
  final String coverUrl;
  final String description;
  final int novelId;
  final String source;
  final String status;
  final String title;
  //will be generated when details is shown
  final List<Genre> genreList;
  final List<Chapter> chaptersList;

  Novel(
      {required this.altTitle,
      required this.author,
      required this.coverUrl,
      required this.description,
      required this.novelId,
      required this.source,
      required this.status,
      required this.title,
      this.genreList = const [],
      this.chaptersList = const []});

  //for viewing novels list
  //creates a novel object :D
  static fromJson(Map<String, dynamic> json) => Novel(
      altTitle: json["altTitle"],
      author: json["author"],
      coverUrl: json["coverUrl"],
      description: json["description"],
      novelId: json["novelId"],
      source: json["source"],
      status: json["status"],
      title: json["title"]);
}
