import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import 'detail_screen.dart';

class UnlimitedScreen extends StatefulWidget {
  const UnlimitedScreen({super.key});

  @override
  State<UnlimitedScreen> createState() => _UnlimitedScreenState();
}

class _UnlimitedScreenState extends State<UnlimitedScreen> {
  List<dynamic> _sections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUnlimited();
  }

  Future<void> _fetchUnlimited() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/unlimited'),
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        setState(() {
          _sections = (data is List) ? data : (data['list'] as List? ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetch unlimited: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A-Z Anime List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final list = section['animeList'] as List;
                return ExpansionTile(
                  title: Text(
                    section['startWith'] ?? section['letter'] ?? '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  children: list.map((anime) {
                    return ListTile(
                      title: Text(anime['title'] ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(animeId: anime['animeId']),
                          ),
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
