import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'data.dart';

class CleoAppBar extends StatefulWidget implements PreferredSizeWidget {
  CleoAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CleoAppBarState createState() => _CleoAppBarState();
}

class _CleoAppBarState extends State<CleoAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "cleo",
        style: TextStyle(color: Data.cleo_blue, fontFamily: "GT-Flexa"),
        textScaleFactor: 2.0,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
    );
  }
}
