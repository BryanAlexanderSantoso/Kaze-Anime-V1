import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/anime_model.dart';
import '../models/schedule_model.dart';
import '../models/anime_detail_model.dart';

class AnimeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AnimeModel> _ongoingAnime = [];
  List<AnimeModel> _completedAnime = [];
  List<ScheduleTileModel> _schedule = [];
  List<GenreModel> _genres = [];
  bool _isLoading = false;

  List<AnimeModel> get ongoingAnime => _ongoingAnime;
  List<AnimeModel> get completedAnime => _completedAnime;
  List<ScheduleTileModel> get schedule => _schedule;
  List<GenreModel> get genres => _genres;
  bool get isLoading => _isLoading;

  Future<void> fetchHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.getHome();
      _ongoingAnime = data['ongoing'] ?? [];
      _completedAnime = data['completed'] ?? [];
    } catch (e) {
      debugPrint('Error fetchHome: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchedule() async {
    _isLoading = true;
    notifyListeners();
    try {
      _schedule = await _apiService.getSchedule();
    } catch (e) {
      debugPrint('Error fetchSchedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGenres() async {
    _isLoading = true;
    notifyListeners();
    try {
      _genres = await _apiService.getGenres();
    } catch (e) {
      debugPrint('Error fetchGenres: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<AnimeModel>> searchAnime(String query) async {
    try {
      return await _apiService.searchAnime(query);
    } catch (e) {
      debugPrint('Error searchAnime: $e');
      return [];
    }
  }
}
