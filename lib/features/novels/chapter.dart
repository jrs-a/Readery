class Chapter {
  final String chapterBody;
  final int chapterIndex;
  final String chapterTitle;
  final int index;
  final int novelId;

  const Chapter(
      {required this.chapterBody,
      required this.chapterIndex,
      required this.chapterTitle,
      required this.index,
      required this.novelId});

  factory Chapter.fromMap(Map<String, dynamic> data) {
    return Chapter(
        chapterBody: data['chapterBody'] as String,
        chapterIndex: data['chapterIndex'] as int,
        chapterTitle: data['chapterTitle'] as String,
        index: data['index'] as int,
        novelId: data['novelId'] as int);
  }

  Map<String, dynamic> toMap() => {
        'chapterBody': chapterBody,
        'chapterIndex': chapterIndex,
        'chapterTitle': chapterTitle,
        'index': index,
        'novelId': novelId
      };
}
