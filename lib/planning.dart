import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Planning extends StatefulWidget {
  const Planning({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  int currentIndex = getWeekNumber(DateTime.now()) - 36;
  int currentYear = 3; // Index de la semaine par défaut (S3)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 175,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 9, 88, 207),
                          Color.fromARGB(255, 9, 88, 207),
                          Colors.white,
                          //add more colors
                        ]),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                        value: currentYear,
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('A1'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('A2'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('A3'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            currentYear = value as int;
                          });
                        },
                        isExpanded:
                            true, //make true to take width of parent widget
                        underline: Container(), //empty line
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        dropdownColor: const Color.fromARGB(255, 9, 88, 207),
                        iconEnabledColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 175,
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Colors.white,
                          Color.fromARGB(255, 9, 88, 207),
                          Color.fromARGB(255, 9, 88, 207),
                          //add more colors
                        ]),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 12),
                      child: Text(
                        'Semaine ${currentIndex + 1}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 9 / 9,
              child: PageView.builder(
                itemCount: getWeekNumber(DateTime.now()) - 35,
                controller: PageController(initialPage: currentIndex),
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return FutureBuilder<Widget>(
                    future: getPdf(index, currentYear),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return snapshot.data ??
                            Container(); // Affiche le PDF s'il est disponible
                      } else {
                        return const CircularProgressIndicator(); // Affiche un indicateur de chargement en attendant
                      }
                    },
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
    return const PDF(
      enableSwipe: true,
      swipeHorizontal: true,
      fitPolicy: FitPolicy.BOTH,
    ).cachedFromUrl(
      pdfUrl,
      placeholder: (double progress) => Center(child: Text('$progress %')),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
  }
}

Future<Widget> getPdf(index, currentYear) async {
  return Center(
    child: PDFViewerFromUrl(
      pdfUrl:
          'http://edt-iut-info.unilim.fr/edt/A$currentYear/A${currentYear}_S${index + 1}.pdf',
    ),
  );
}

getWeekNumber(DateTime date) {
  final oneJan = DateTime(date.year, 1, 1);
  return ((date.difference(oneJan).inDays + oneJan.weekday) / 7).ceil();
}
