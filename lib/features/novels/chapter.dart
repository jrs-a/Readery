class Chapter {
  final int chapterId;
  final String chapterTitle;
  final String chapterBody;
  final int novelId; //fk to Novel many to many

  Chapter(this.chapterId, this.chapterTitle, this.chapterBody, this.novelId);
}
