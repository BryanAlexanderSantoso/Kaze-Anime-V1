import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/anime_model.dart';
import '../widgets/anime_card.dart';

class ListAllScreen extends StatefulWidget {
  final String type; // 'ongoing' or 'completed'
  final String? genreId;
  final String? genreTitle;

  const ListAllScreen({
    super.key,
    required this.type,
    this.genreId,
    this.genreTitle,
  });

  @override
  State<ListAllScreen> createState() => _ListAllScreenState();
}

class _ListAllScreenState extends State<ListAllScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<AnimeModel> _animeList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      List<AnimeModel> newAnime = [];
      if (widget.type == 'ongoing') {
        newAnime = await _apiService.getOngoingAnime(page: _currentPage);
      } else if (widget.type == 'completed') {
        newAnime = await _apiService.getCompleteAnime(page: _currentPage);
      } else if (widget.type == 'genre') {
        newAnime = await _apiService.getAnimeByGenre(
          widget.genreId!,
          page: _currentPage,
        );
      }

      if (newAnime.isEmpty) {
        _hasMore = false;
      } else {
        setState(() {
          _animeList.addAll(newAnime);
          _currentPage++;
        });
      }
    } catch (e) {
      debugPrint('Error fetch data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.type == 'ongoing'
        ? 'Ongoing Anime'
        : widget.type == 'completed'
        ? 'Completed Anime'
        : widget.genreTitle ?? 'Genre Anime';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _animeList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _animeList.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _animeList.length) {
                  return AnimeCard(
                    anime: _animeList[index],
                    width: double.infinity,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
