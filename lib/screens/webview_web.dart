import 'dart:ui_web' as ui_web;
import 'dart:html' as html;
import 'package:flutter/material.dart';

Widget getWebWebView(String url) {
  final String viewId = 'iframe-${url.hashCode}';

  // Register the iframe once
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) => html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..allowFullscreen = true,
  );

  return HtmlElementView(viewType: viewId);
}
