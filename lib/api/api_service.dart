import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';
import '../models/anime_detail_model.dart';
import '../models/streaming_model.dart';
import '../models/schedule_model.dart';
import '../models/batch_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.sankavollerei.com/anime';

  Future<BatchModel> getBatch(String batchId) async {
    final response = await http.get(Uri.parse('$baseUrl/batch/$batchId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return BatchModel.fromJson(data);
    } else {
      throw Exception('Failed to load batch data');
    }
  }

  Future<Map<String, List<AnimeModel>>> getHome() async {
    final response = await http.get(Uri.parse('$baseUrl/home'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final ongoingList = (data['ongoing']['animeList'] as List)
          .map((e) => AnimeModel.fromJson(e))
          .toList();
      final completedList = (data['completed']['animeList'] as List)
          .map((e) => AnimeModel.fromJson(e))
          .toList();
      return {'ongoing': ongoingList, 'completed': completedList};
    } else {
      throw Exception('Failed to load home data');
    }
  }

  Future<List<ScheduleTileModel>> getSchedule() async {
    final response = await http.get(Uri.parse('$baseUrl/schedule'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => ScheduleTileModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  Future<List<AnimeModel>> searchAnime(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$query'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      final list = (data is List) ? data : (data['animeList'] as List? ?? []);
      return list.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search anime');
    }
  }

  Future<AnimeDetailModel> getAnimeDetail(String animeId) async {
    final response = await http.get(Uri.parse('$baseUrl/anime/$animeId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return AnimeDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load anime detail');
    }
  }

  Future<StreamingModel> getStreaming(String episodeId) async {
    final response = await http.get(Uri.parse('$baseUrl/episode/$episodeId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StreamingModel.fromJson(data);
    } else {
      throw Exception('Failed to load streaming data');
    }
  }

  Future<String> getServerUrl(String serverId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/server/$serverId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data != null && data['url'] != null) {
          return data['url'];
        }
      }
    } catch (e) {
      debugPrint('Default server API failed, trying fallback...');
    }

    // Fallback to Samehadaku API
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/samehadaku/server/$serverId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data != null && data['url'] != null) {
          return data['url'];
        }
      }
    } catch (e) {
      debugPrint('Fallback server API failed: $e');
    }

    throw Exception('Failed to load server URL from all sources');
  }

  Future<List<GenreModel>> getGenres() async {
    final response = await http.get(Uri.parse('$baseUrl/genre'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      final list = (data is List) ? data : (data['genreList'] as List? ?? []);
      return list.map((e) => GenreModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<AnimeModel>> getAnimeByGenre(
    String genreId, {
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/$genreId?page=$page'),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      final list = (data is List) ? data : (data['animeList'] as List? ?? []);
      return list.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load anime by genre');
    }
  }

  Future<List<AnimeModel>> getOngoingAnime({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ongoing-anime?page=$page'),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      final list = (data is List) ? data : (data['animeList'] as List? ?? []);
      return list.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ongoing anime');
    }
  }

  Future<List<AnimeModel>> getCompleteAnime({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/complete-anime?page=$page'),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      final list = (data is List) ? data : (data['animeList'] as List? ?? []);
      return list.map((e) => AnimeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load complete anime');
    }
  }
}
