import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../widgets/anime_card.dart';
import 'list_all_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimeProvider>().fetchHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Crunchyroll_Logo.svg/1024px-Crunchyroll_Logo.svg.png',
          height: 24,
          color: const Color(0xFFF47521),
          errorBuilder: (context, error, stackTrace) => const Text('KAZE V1'),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Consumer<AnimeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.ongoingAnime.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final featuredAnime = provider.ongoingAnime.isNotEmpty
              ? provider.ongoingAnime.first
              : null;

          return RefreshIndicator(
            onRefresh: () => provider.fetchHome(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (featuredAnime != null)
                    _buildFeaturedBanner(context, featuredAnime),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          context,
                          'Up to Date',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ListAllScreen(type: 'ongoing'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.ongoingAnime.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 140,
                                margin: const EdgeInsets.only(right: 12),
                                child: AnimeCard(
                                  anime: provider.ongoingAnime[index],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          context,
                          'Recently Added',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ListAllScreen(type: 'completed'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 20,
                              ),
                          itemCount: provider.completedAnime.take(6).length,
                          itemBuilder: (context, index) {
                            return AnimeCard(
                              anime: provider.completedAnime[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBanner(BuildContext context, anime) {
    return Stack(
      children: [
        Container(
          height: 450,
          width: double.infinity,
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.3, 0.7, 1],
            ),
          ),
          child: Image.network(anime.poster, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 40,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Text(
                anime.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow, color: Colors.black),
                    label: const Text(
                      'WATCH NOW',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF47521),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white24,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'VIEW ALL',
            style: TextStyle(
              color: Color(0xFFF47521),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
