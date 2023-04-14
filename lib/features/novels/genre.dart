class Genre {
  final int genreId;
  final String genre;
  final List novelIds; //fk to Novel many to many

  Genre(this.genreId, this.genre, this.novelId);
}
