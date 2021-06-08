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
                  if (commitment.successfulDays["0"] == null) {
                    displayColor = Data.paper_white;
                  } else if (commitment.successfulDays["0"] ?? false) {
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
                  child: Text("Done"), onPressed: () => Navigator.pop(context)
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
  Future<void> giveRoastAboutCheckIn(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Commitment Failure"),
        content: const Text(
            "That's 3 times you've failed this commitment in a row!\nGet your **** together"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I'll get better, I promise!"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nah, I give up"),
          ),
        ],
      ),
    );
  }

  Future<void> giveHypeAboutCheckIn(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Commitment Awesomeness"),
        content: Text(
            "You've nailed this commitment 3 times in a row!\nYou'll get your ${widget.goal.name} soon!"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yay, I'm awesome!"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("I can't wait for that ${widget.goal.name}!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
            CommitmentModel commitment =
            widget.goal.commitments.elementAt(index);
            return ListTile(
              title: Text("${commitment.name}"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: (commitment.successfulDays["0"] ?? false)
                            ? Data.cleo_blue_tint_3
                            : null),
                    child: IconButton(
                        icon: Icon(Icons.sentiment_very_satisfied,
                            color: Data.dollar_green),
                        onPressed: () {
                          if (commitment.name == "Walk instead of the bus") {
                            this.giveHypeAboutCheckIn(context);
                          }
                          setState(() {
                            commitment.successfulDays["0"] = true;
                            // TODO Notify datastore
                          });
                        })),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: !(commitment.successfulDays["0"] ?? true)
                          ? Data.cleo_blue_tint_2
                          : null),
                  child: IconButton(
                      icon: Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Data.roast_red,
                      ),
                      onPressed: () {
                        if (commitment.name == "Resist the Greggs") {
                          this.giveRoastAboutCheckIn(context);
                        }
                        setState(() {
                          commitment.successfulDays["0"] = false;
                          // TODO Notify datastore
                        });
                        // TODO Notify datastore
                      }),
                )
              ]),
            );
          },
          itemCount: widget.goal.commitments.length,
        ),
      ),
    );
  }
}
