class AnimeModel {
  final String title;
  final String poster;
  final String? episodes;
  final String? releaseDay;
  final String? latestReleaseDate;
  final String animeId;
  final String? score;

  AnimeModel({
    required this.title,
    required this.poster,
    this.episodes,
    this.releaseDay,
    this.latestReleaseDate,
    required this.animeId,
    this.score,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      title: json['title'] ?? '',
      poster: json['poster'] ?? '',
      episodes: json['episodes']?.toString(),
      releaseDay: json['releaseDay'],
      latestReleaseDate: json['latestReleaseDate'] ?? json['lastReleaseDate'],
      animeId: json['animeId'] ?? '',
      score: json['score']?.toString(),
    );
  }
}
