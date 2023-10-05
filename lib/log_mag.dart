import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class LogMag extends StatelessWidget {
  const LogMag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFViewerFromAsset(
        pdfAssetPath: 'assets/pdfs/logmag21_mars2023.pdf',
      ),
    );
  }
}

class PDFViewerFromAsset extends StatelessWidget {
  PDFViewerFromAsset({Key? key, required this.pdfAssetPath}) : super(key: key);
  final String pdfAssetPath;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                StreamBuilder<String>(
                    stream: _pageCountController.stream,
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(snapshot.data!,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 80, 121, 196))),
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                AspectRatio(
                  aspectRatio: 9 / 11.2,
                  child: PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    onPageChanged: (int? current, int? total) =>
                        _pageCountController.add('${current! + 1} - $total'),
                    onViewCreated: (PDFViewController pdfViewController) async {
                      _pdfViewController.complete(pdfViewController);
                      final int currentPage =
                          await pdfViewController.getCurrentPage() ?? 0;
                      final int? pageCount =
                          await pdfViewController.getPageCount();
                      _pageCountController
                          .add('${currentPage + 1} - $pageCount');
                    },
                  ).fromAsset(
                    pdfAssetPath,
                    errorWidget: (dynamic error) =>
                        Center(child: Text(error.toString())),
                  ),
                ),
              ],
            )));
  }
}
