import 'anime_model.dart';

class ScheduleTileModel {
  final String day;
  final List<AnimeModel> animeList;

  ScheduleTileModel({required this.day, required this.animeList});

  factory ScheduleTileModel.fromJson(Map<String, dynamic> json) {
    return ScheduleTileModel(
      day: json['day'] ?? '',
      animeList:
          (json['anime_list'] as List?)
              ?.map(
                (e) => AnimeModel(
                  title: e['title'] ?? '',
                  poster: e['poster'] ?? '',
                  animeId: e['slug'] ?? '',
                ),
              )
              .toList() ??
          [],
    );
  }
}
