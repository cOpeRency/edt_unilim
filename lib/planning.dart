import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:http/http.dart' as http;

class Planning extends StatefulWidget {
  const Planning({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  int currentIndex = getWeekNumber(DateTime.now()) - 37;
  int currentYear = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AdaptiveTheme.of(context).mode.isDark
                                  ? const Color.fromRGBO(255, 255, 255, 0.57)
                                  : const Color.fromRGBO(0, 0, 0, 0.57),
                              blurRadius: 5)
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
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 80, 121, 196)),
                        dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                        iconEnabledColor: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AdaptiveTheme.of(context).mode.isDark
                                  ? const Color.fromRGBO(255, 255, 255, 0.57)
                                  : const Color.fromRGBO(0, 0, 0, 0.57),
                              blurRadius: 5)
                        ]),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 12),
                      child: Text(
                        'Semaine ${currentIndex + 1}',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 80, 121, 196)),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureZoomBox(
              maxScale:
                  3.0, // La valeur maximale de zoom que vous souhaitez autoriser
              doubleTapScale:
                  2.0, // La valeur de zoom lorsqu'un double-clic est effectué
              duration: const Duration(
                  milliseconds: 100), // Durée de l'animation de zoom
              child: AspectRatio(
                aspectRatio: 12.5 / 8.8,
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
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return snapshot.data ?? Container();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: Text("Erreur de chargement du PDF"),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<Widget> getPdf(index, currentYear) async {
  final pdfUrl =
      'http://edt-iut-info.unilim.fr/edt/A$currentYear/A${currentYear}_S${index + 1}.pdf';

  try {
    // Vérifiez si l'URL est valide en effectuant une requête HTTP HEAD.
    final headResponse = await http.head(Uri.parse(pdfUrl));

    if (headResponse.statusCode == 200 &&
        headResponse.headers['content-type'] == 'application/pdf') {
      return Center(
        child: const PDF(
          enableSwipe: true,
          swipeHorizontal: true,
          fitPolicy: FitPolicy.BOTH,
        ).cachedFromUrl(
          pdfUrl,
          placeholder: (double progress) => Center(child: Text('$progress %')),
          errorWidget: (dynamic error) =>
              const Center(child: Text("PDF non disponible")),
        ),
      );
    } else {
      return const Center(child: Text("Le PDF n'est pas disponible"));
    }
  } catch (e) {
    return Center(child: Text("Erreur de chargement du PDF : $e"));
  }
}

getWeekNumber(DateTime date) {
  final oneJan = DateTime(date.year, 1, 1);
  return ((date.difference(oneJan).inDays + oneJan.weekday) / 7).ceil();
}
