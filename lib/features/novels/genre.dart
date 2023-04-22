class Genre {
  final int genreId;
  final String genre;
  final List novelIds;

  Genre(this.genreId, this.genre, this.novelIds); //fk to Novel many to many
}
