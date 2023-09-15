import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Planning extends StatefulWidget {
  const Planning({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  int currentIndex = 2; // Index de la semaine par défaut (S3)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 9 / 9,
              child: PageView.builder(
                itemCount: 3, // 3 semaines (S1, S2, S3)
                controller: PageController(initialPage: currentIndex),
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                        'Semaine ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18, // Ajuster la taille de la police
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: PDFViewerFromUrl(
                          pdfUrl:
                              'http://edt-iut-info.unilim.fr/edt/A3/A3_S${index + 1}.pdf',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.pdfUrl}) : super(key: key);

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return const PDF().cachedFromUrl(
      pdfUrl,
      placeholder: (double progress) => Center(child: Text('$progress %')),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
  }
}
