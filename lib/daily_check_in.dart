import 'dart:collection';

import 'package:cleo_hackathon/cleo_appbar.dart';
import 'package:cleo_hackathon/commitment_model.dart';
import 'package:cleo_hackathon/goal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';

class DailyCheckInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CleoAppBar(),
      body: _DailyCheckIn(),
    );
  }
}

class _DailyCheckIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DailyCheckInState();
}

class DailyCheckInState extends State<_DailyCheckIn> {
  List<GoalModel> goals = [
    GoalModel.templateOne(),
    GoalModel.templateTwo(),
    GoalModel.templateThree()
  ];
  String today = "today";

  @override
  Widget build(BuildContext context) {
    LinkedHashSet<CommitmentModel> allCommitments =
        this.goals.fold(LinkedHashSet(), (previousValue, goal) {
      previousValue.addAll(goal.commitments);
      return previousValue;
    });
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
          Text(
            "Daily Check In",
            style: GoogleFonts.archivoBlack(),
            textScaleFactor: 1.8,
          ),
          SizedBox(
            height: 16,
          ),
          Container(
              height: 32,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            child: Text("Status:"),
                            padding: EdgeInsets.all((8)))); //8, 0, 0, 8),));
                  }
                  CommitmentModel commitment =
                      allCommitments.elementAt(index - 1);
                  Color displayColor = Data.paper_white;
                  if (commitment.successfulDays[today] == null) {
                    displayColor = Data.paper_white;
                  } else if (commitment.successfulDays[today] ?? false) {
                    displayColor = Data.dollar_green;
                  } else {
                    displayColor = Data.roast_red;
                  }
                  return SizedBox(
                    width: 32,
                    //height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: displayColor),
                    ),
                  );
                },
                itemCount: allCommitments.length + 1,
              )),
          SizedBox(
            height: 16,
          ),
          Flexible(
              child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GoalCheckIn(goals.elementAt(index));
            },
            itemCount: goals.length,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(primary: Data.roast_red)),
              SizedBox(width: 16),
              ElevatedButton(
                  child: Text("Done!"), onPressed: () => Navigator.pop(context)
                  // TODO Send new goal to data store
                  ),
            ],
          ),
        ]));
  }
}

class GoalCheckIn extends StatefulWidget {
  final GoalModel goal;

  GoalCheckIn(this.goal);

  @override
  State createState() => GoalCheckInState();
}

class GoalCheckInState extends State<GoalCheckIn> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Padding(
          child: Text(
            "${widget.goal.name}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.all(8),
        ),
        subtitle: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Data.boss_black,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("${widget.goal.commitments.elementAt(index).name}"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    icon: Icon(Icons.sentiment_very_satisfied,
                        color: Data.dollar_green),
                    onPressed: () {
                      setState(() {
                        // TODO Notify datastore
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Data.roast_red,
                    ),
                    onPressed: () {
                      // TODO Notify datastore
                    }),
              ]),
            );
          },
          itemCount: widget.goal.commitments.length,
        ),
      ),
    );
  }
}
