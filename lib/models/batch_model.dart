class BatchModel {
  final String title;
  final String? poster;
  final List<DownloadFormat> formats;

  BatchModel({required this.title, this.poster, required this.formats});

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      title: json['title'] ?? '',
      poster: json['poster'],
      formats:
          (json['downloadUrl']?['formats'] as List?)
              ?.map((e) => DownloadFormat.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DownloadFormat {
  final String title;
  final List<DownloadQuality> qualities;

  DownloadFormat({required this.title, required this.qualities});

  factory DownloadFormat.fromJson(Map<String, dynamic> json) {
    return DownloadFormat(
      title: json['title'] ?? '',
      qualities:
          (json['qualities'] as List?)
              ?.map((e) => DownloadQuality.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DownloadQuality {
  final String title;
  final String size;
  final List<DownloadLink> links;

  DownloadQuality({
    required this.title,
    required this.size,
    required this.links,
  });

  factory DownloadQuality.fromJson(Map<String, dynamic> json) {
    return DownloadQuality(
      title: json['title'] ?? '',
      size: json['size'] ?? '',
      links:
          (json['urls'] as List?)
              ?.map((e) => DownloadLink.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DownloadLink {
  final String title;
  final String url;

  DownloadLink({required this.title, required this.url});

  factory DownloadLink.fromJson(Map<String, dynamic> json) {
    return DownloadLink(title: json['title'] ?? '', url: json['url'] ?? '');
  }
}
