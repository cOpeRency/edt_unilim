import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class PlanningView extends StatelessWidget {
  String url;
  PlanningView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFViewerCachedFromUrl(
        url: url,
      ),
    );
  }
}



class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}