import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../widgets/anime_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AnimeProvider>().fetchSchedule();
      final scheduleLength = context.read<AnimeProvider>().schedule.length;
      if (mounted) {
        setState(() {
          _tabController = TabController(length: scheduleLength, vsync: this);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Release Schedule'),
        bottom: context.watch<AnimeProvider>().schedule.isEmpty
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: const Color(0xFF6C63FF),
                tabs: context
                    .watch<AnimeProvider>()
                    .schedule
                    .map((e) => Tab(text: e.day))
                    .toList(),
              ),
      ),
      body: Consumer<AnimeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.schedule.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.schedule.isEmpty) {
            return const Center(child: Text('No schedule available'));
          }

          return TabBarView(
            controller: _tabController,
            children: provider.schedule.map((day) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: day.animeList.length,
                itemBuilder: (context, index) {
                  return AnimeCard(
                    anime: day.animeList[index],
                    width: double.infinity,
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
