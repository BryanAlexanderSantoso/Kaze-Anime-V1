import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../models/anime_model.dart';
import '../widgets/anime_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<AnimeModel> _searchResults = [];
  bool _isSearching = false;

  void _onSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isSearching = true);
    final results = await context.read<AnimeProvider>().searchAnime(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search anime...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: _onSearch,
        ),
        actions: [
          IconButton(
            onPressed: () => _onSearch(_controller.text),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search for your favorite anime',
                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return AnimeCard(
                  anime: _searchResults[index],
                  width: double.infinity,
                );
              },
            ),
    );
  }
}
