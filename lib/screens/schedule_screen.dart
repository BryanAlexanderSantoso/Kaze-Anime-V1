import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../widgets/anime_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.schedule.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF47521)),
          );
        }

        if (provider.schedule.isEmpty) {
          return const Center(
            child: Text(
              'No schedule available',
              style: TextStyle(color: Colors.white60),
            ),
          );
        }

        return DefaultTabController(
          length: provider.schedule.length,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                const SizedBox(height: 60), // Space for top status bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'RELEASE SCHEDULE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TabBar(
                  isScrollable: true,
                  indicatorColor: const Color(0xFFF47521),
                  labelColor: const Color(0xFFF47521),
                  unselectedLabelColor: Colors.white38,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: provider.schedule
                      .map((e) => Tab(text: e.day.toUpperCase()))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: provider.schedule.map((day) {
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 20,
                            ),
                        itemCount: day.animeList.length,
                        itemBuilder: (context, index) {
                          return AnimeCard(anime: day.animeList[index]);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
