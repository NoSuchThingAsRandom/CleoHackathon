import 'package:cleo_hackathon/goal_modification.dart';
import 'package:flutter/material.dart';

class Goals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: ElevatedButton(
          child: Text("Create Goal"),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => GoalModification(null))),
        ));
  }
}
