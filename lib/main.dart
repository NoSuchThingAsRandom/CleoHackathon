import 'package:cleo_hackathon/cleo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_page.dart';
import 'data.dart';
import 'goals.dart';

void main() {
  runApp(Cleo());
}

class Cleo extends StatelessWidget {
  const Cleo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cleo',
        theme: ThemeData(
            primarySwatch: Data.material_cleo_blue,
            accentColor: Data.material_cleo_blue_tint_3,
            scaffoldBackgroundColor: Data.material_cleo_blue_tint_3,
            textTheme: GoogleFonts.archivoTextTheme()),
        home: CleoApp());
  }
}

class CleoApp extends StatefulWidget {
  const CleoApp({Key? key}) : super(key: key);

  @override
  State<CleoApp> createState() => _CleoAppState();
}

class _CleoAppState extends State<CleoApp> {
  int _selectedIndex = 0;
  List<Widget> _screens = <Widget>[
    ChatPage(),
    Goals(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CleoAppBar(),
        body: _screens.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            // TODO Create better icons
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Goals")
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
