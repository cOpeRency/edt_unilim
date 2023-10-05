import 'package:edt_unilim/planning2.dart';
import 'package:flutter/material.dart';


class Planning extends StatefulWidget {
  const Planning({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  ValueNotifier<int> currentIndex = ValueNotifier<int>(getWeekNumber(DateTime.now()) - 37);
  ValueNotifier<int> currentYear = ValueNotifier<int>(3);

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
              padding: const EdgeInsets.only(bottom: 10, top : 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 175,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 9, 88, 207),
                          Color.fromARGB(255, 9, 88, 207),
                          Color.fromARGB(255, 99, 155, 239)
                          //add more colors
                        ]),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                        value: currentYear.value,
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
                            currentYear.value = value as int;
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
                          Color.fromARGB(255, 99, 155, 239),
                          Color.fromARGB(255, 9, 88, 207),
                          Color.fromARGB(255, 9, 88, 207)
                          //add more colors
                        ]),
                        borderRadius: BorderRadius.circular(50),
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
                        'Semaine ${currentIndex.value + 1}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            ValueListenableBuilder<int>(
              builder: (BuildContext context, int value, Widget? child) {
                return Expanded(child: PlanningView(url:'http://edt-iut-info.unilim.fr/edt/A${currentYear.value}/A${currentYear.value}_S${currentIndex.value}.pdf'));
              },
              valueListenable: currentYear,
            )
          ],
        ),
      ),
    );
  }
}

getWeekNumber(DateTime date) {
  final oneJan = DateTime(date.year, 1, 1);
  return ((date.difference(oneJan).inDays + oneJan.weekday) / 7).ceil();
}

