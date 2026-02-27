class StreamingModel {
  final List<QualityModel> qualities;

  StreamingModel({required this.qualities});

  factory StreamingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null) return StreamingModel(qualities: []);

    // Try all known keys for quality list
    dynamic qualitiesList;

    if (data['serverUrl'] != null && data['serverUrl']['qualities'] != null) {
      qualitiesList = data['serverUrl']['qualities'];
    } else if (data['server'] != null && data['server']['qualities'] != null) {
      qualitiesList = data['server']['qualities'];
    } else if (data['streamUrl'] != null) {
      qualitiesList = data['streamUrl'];
    }

    return StreamingModel(
      qualities:
          (qualitiesList as List?)
              ?.map((e) => QualityModel.fromJson(e))
              .where(
                (q) => q.servers.isNotEmpty,
              ) // Only include qualities with servers
              .toList() ??
          [],
    );
  }
}

class QualityModel {
  final String title;
  final List<ServerModel> servers;

  QualityModel({required this.title, required this.servers});

  factory QualityModel.fromJson(Map<String, dynamic> json) {
    return QualityModel(
      title: json['title'] ?? '',
      servers:
          (json['serverList'] as List?)
              ?.map((e) => ServerModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ServerModel {
  final String title;
  final String serverId;

  ServerModel({required this.title, required this.serverId});

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      title: json['title'] ?? '',
      serverId: json['serverId'] ?? '',
    );
  }
}
