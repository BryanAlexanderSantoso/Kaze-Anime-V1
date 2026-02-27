import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_service.dart';
import '../models/batch_model.dart';

class BatchScreen extends StatefulWidget {
  final String batchId;

  const BatchScreen({super.key, required this.batchId});

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  final ApiService _apiService = ApiService();
  BatchModel? _batch;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBatch();
  }

  Future<void> _fetchBatch() async {
    try {
      final batch = await _apiService.getBatch(widget.batchId);
      setState(() {
        _batch = batch;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch batch: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Batch Download')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _batch == null
          ? const Center(child: Text('Failed to load batch data'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _batch!.formats.length,
              itemBuilder: (context, index) {
                final format = _batch!.formats[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      format.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...format.qualities.map((quality) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${quality.title} (${quality.size})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: quality.links.map((link) {
                              return ElevatedButton(
                                onPressed: () => _launchUrl(link.url),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A1A2E),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: const Color(
                                      0xFF6C63FF,
                                    ).withOpacity(0.5),
                                  ),
                                ),
                                child: Text(link.title),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    const Divider(height: 32),
                  ],
                );
              },
            ),
    );
  }
}
