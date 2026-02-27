import 'package:flutter/foundation.dart';

class ImageUtils {
  /// Proxy image URL to bypass CORS issues on Flutter Web.
  /// Uses images.weserv.nl which is a free image cache/proxy.
  static String getSafeImageUrl(String url) {
    if (url.isEmpty) return url;

    // If it's Web, use the proxy. On mobile, we can use the direct URL.
    if (kIsWeb) {
      // Remove protocol if exists to avoid double protocol in URL
      String cleanUrl = url
          .replaceFirst('https://', '')
          .replaceFirst('http://', '');
      return 'https://images.weserv.nl/?url=$cleanUrl&default=$url';
    }

    return url;
  }
}
