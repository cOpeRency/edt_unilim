import 'package:edt_unilim/planning.dart';
import 'package:edt_unilim/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:edt_unilim/log_mag.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: "Adaptive Theme",
        theme: theme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Planning(),
    const LogMag(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AdaptiveTheme.of(context).mode.isDark
                        ? AdaptiveTheme.of(context).setLight()
                        : AdaptiveTheme.of(context).setDark();
                  },
                  child: Text(
                    "Mode Sombre",
                    style: TextStyle(
                      fontSize: 13,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white
                          : const Color.fromARGB(255, 80, 121, 196),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.png',
                  scale: 9,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10,
                vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: const Color.fromARGB(255, 80, 121, 196),
              iconSize: 24,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20,
                  vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tabs: const [
                GButton(
                  icon: Icons.table_view_rounded,
                  text: 'Emploi du temps',
                ),
                GButton(
                  icon: Icons.newspaper_rounded,
                  text: 'Log_Mag',
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
