class AnimeDetailModel {
  final String title;
  final String poster;
  final String? japanese;
  final String? score;
  final String? producers;
  final String? type;
  final String? status;
  final String? duration;
  final String? aired;
  final String? studios;
  final String synopsis;
  final List<GenreModel> genres;
  final List<EpisodeModel> episodes;
  final Map<String, dynamic>? batch;

  AnimeDetailModel({
    required this.title,
    required this.poster,
    this.japanese,
    this.score,
    this.producers,
    this.type,
    this.status,
    this.duration,
    this.aired,
    this.studios,
    required this.synopsis,
    required this.genres,
    required this.episodes,
    this.batch,
  });

  factory AnimeDetailModel.fromJson(Map<String, dynamic> json) {
    return AnimeDetailModel(
      title: json['title'] ?? '',
      poster: json['poster'] ?? '',
      japanese: json['japanese'],
      score: json['score']?.toString(),
      producers: json['producers'],
      type: json['type'],
      status: json['status'],
      duration: json['duration'],
      aired: json['aired'],
      studios: json['studios'],
      synopsis: (json['synopsis']?['paragraphs'] as List?)?.join('\n') ?? '',
      genres:
          (json['genreList'] as List?)
              ?.map((e) => GenreModel.fromJson(e))
              .toList() ??
          [],
      episodes:
          (json['episodeList'] as List?)
              ?.map((e) => EpisodeModel.fromJson(e))
              .toList() ??
          [],
      batch: json['batch'],
    );
  }
}

class GenreModel {
  final String title;
  final String genreId;

  GenreModel({required this.title, required this.genreId});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      title: json['title'] ?? '',
      genreId: json['genreId'] ?? '',
    );
  }
}

class EpisodeModel {
  final String title;
  final String episodeId;
  final String? date;
  final double? eps;

  EpisodeModel({
    required this.title,
    required this.episodeId,
    this.date,
    this.eps,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      title: json['title'] ?? '',
      episodeId: json['episodeId'] ?? '',
      date: json['date'],
      eps: (json['eps'] as num?)?.toDouble(),
    );
  }
}
