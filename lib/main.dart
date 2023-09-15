import 'package:edt_unilim/planning.dart';
import 'package:edt_unilim/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() => runApp(MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      title: 'GNav',
      theme: ThemeData(
        primaryColor: Colors.grey[800],
      ),
    ));

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const Planning(),
    const Text(
      'Log_Mag',
      style: optionStyle,
    ),
    const Text(
      'Paramètres',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Image.asset(
          'assets/images/Logo.png',
          scale: 10,
        )),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.table_view_rounded,
                  text: 'Planning',
                ),
                GButton(
                  icon: Icons.newspaper_rounded,
                  text: 'Log_Mag',
                ),
                GButton(
                  icon: Icons.settings_rounded,
                  text: 'Paramètres',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
