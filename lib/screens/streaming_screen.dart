import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/streaming_model.dart';
import 'webview_screen.dart';
import 'package:flutter/foundation.dart';

class StreamingScreen extends StatefulWidget {
  final String episodeId;
  final String episodeTitle;

  const StreamingScreen({
    super.key,
    required this.episodeId,
    required this.episodeTitle,
  });

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  final ApiService _apiService = ApiService();
  StreamingModel? _streamingData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStreamingData();
  }

  Future<void> _fetchStreamingData() async {
    try {
      final data = await _apiService.getStreaming(widget.episodeId);
      setState(() {
        _streamingData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch streaming: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playServer(ServerModel server) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final url = await _apiService.getServerUrl(server.serverId);
      if (mounted) {
        Navigator.pop(context); // Pop loading

        // Always navigate to WebViewScreen, regardless of platform
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WebViewScreen(url: url, title: widget.episodeTitle),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading server: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.episodeTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _streamingData == null || _streamingData!.qualities.isEmpty
          ? const Center(child: Text('No streaming servers found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _streamingData!.qualities.length,
              itemBuilder: (context, index) {
                final quality = _streamingData!.qualities[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Quality: ${quality.title}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: quality.servers.map((server) {
                        return ElevatedButton(
                          onPressed: () => _playServer(server),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A2E),
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xFF6C63FF).withOpacity(0.5),
                            ),
                          ),
                          child: Text(server.title),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 32),
                  ],
                );
              },
            ),
    );
  }
}
