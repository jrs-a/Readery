import 'package:readery/features/novels/chapter.dart';
import 'package:readery/features/novels/genre.dart';

class Novel {
  final int novelId;
  final String title;
  final String author;
  final List<Genre> genreList;
  final String description;
  final String status;
  final List<Chapter> chaptersList;

  Novel(this.novelId, this.title, this.author, this.genreList, this.description,
      this.status, this.chaptersList);
}

Genre genre1 = Genre(1, "Action", [1, 2]);
Genre genre2 = Genre(2, "Adventure", [1, 2]);
List<Genre> genresList = [genre1, genre2];

List<Novel> novelList = [
  Novel(1, 'Hello', 'Charles', genresList, 'lorem ipsum dolor sit amet',
      'ongoing', [
    Chapter(1, "Chapter 1", "Lorem ipsum dolor sit amet.", 1),
    Chapter(2, "Chapter 2", "Consectetur adipiscing elit.", 1)
  ]),
  Novel(2, 'World', 'Tom', genresList, 'lorem lorem ipsum ipsum dolor',
      'finished', [
    Chapter(1, "Chapter 1", "Lorem ipsum dolor sit amet.", 2),
    Chapter(2, "Chapter 2", "Consectetur adipiscing elit.", 2)
  ])
];
