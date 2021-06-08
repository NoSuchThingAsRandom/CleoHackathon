import 'package:cleo_hackathon/commitment_modification.dart';
import 'package:cleo_hackathon/goal_backend.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'commitment_model.dart';
import 'daily_check_in.dart';
import 'data.dart';
import 'goal_model.dart';
import 'goal_modification.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    return Consumer<GoalBackend>(builder: (context, goalBackend, child) {
      return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller,
        itemBuilder: (context, index) {
          return Goals(goalBackend.goals.elementAt(index));
        },
        itemCount: goalBackend.goals.length,
      );
    });
  }
}

class Goals extends StatelessWidget {
  Goals(this.goal);

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text(
            goal.name,
            style: GoogleFonts.archivoBlack(),
            textScaleFactor: 1.8,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalModification(this.goal))),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        //graph
        GoalDescription(goal),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        GoalDates(goal),
        Padding(
          padding: EdgeInsets.all(5),
          child: GoalProgressBox(goal),
        ),

        CommitmentList(goal),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text("Daily Check in"),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DailyCheckInPage())),
            ))
      ])),
      Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Data.boss_black_tint_2,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalModification(null))),
          ))
    ]);
  }
}

class CommitmentList extends StatelessWidget {
  final GoalModel goal;

  CommitmentList(this.goal);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(
        "Your commitments: ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.6,
      ),
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
      //some div?
      Center(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: goal.commitments.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${goal.commitments.elementAt(index).name} - £${goal.commitments.elementAt(index).targetAmount} per day",
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () async {
                        final commitment = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommitmentModification(
                                    goal.commitments.elementAt(index))));
                        if (commitment != null) {
                          GoalBackend backend =
                              Provider.of<GoalBackend>(context, listen: false);
                          backend.modifyCommitmentForGoal(
                              this.goal,
                              this.goal.commitments.elementAt(index),
                              commitment);
                        }
                      }),
                ),
              );
            }),
      )
    ]);
  }
}

class GoalDates extends StatelessWidget {
  GoalDates(this.goal);

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: GoalFinishDate(goal.targetDate),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: GoalExpectedDate(goal),
        ),
      ]),
    );
  }
}

class GoalFinishDate extends StatefulWidget {
  GoalFinishDate(this.goalDate);

  final DateTime goalDate;

  @override
  _GoalFinishDate createState() => _GoalFinishDate(goalDate);
}

class _GoalFinishDate extends State<GoalFinishDate> {
  _GoalFinishDate(this.goalDate);

  final DateTime goalDate;
  String dateString = "";

  @override
  void initState() {
    super.initState();
    dateString = "${goalDate.day}-${goalDate.month}-${goalDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.black,
            width: 3,
          )),
      child: Column(children: [
        Text(
          "Target Date",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        Text(
          dateString,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ]),
    );
  }
}

class GoalExpectedDate extends StatefulWidget {
  GoalExpectedDate(this.goal);

  final GoalModel goal;

  @override
  _GoalExpectedDateState createState() => _GoalExpectedDateState(goal);
}

class _GoalExpectedDateState extends State<GoalExpectedDate> {
  _GoalExpectedDateState(this.goal);

  final GoalModel goal;
  int daysToGo = 0;

  int _daysToGo(goal) {
    var remains = (goal.targetAmount - goal.currentAmount);
    var save = 0;
    for (CommitmentModel commit in goal.commitments) {
      save += commit.targetAmount;
    }
    double days = remains / save;
    return days.ceil();
  }

  @override
  void initState() {
    super.initState();
    daysToGo = _daysToGo(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.black,
            width: 3,
          )),
      child: Column(children: [
        Text(
          "Expected days until finish",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        Text(
          "$daysToGo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ]),
    );
  }
}

class GoalDescription extends StatelessWidget {
  GoalDescription(this.goal);

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Text(
      goal.description,
      textScaleFactor: 1.4,
    );
  }
}

class GoalProgressBox extends StatefulWidget {
  GoalProgressBox(this.goal);

  final GoalModel goal;

  @override
  _GoalProgressBoxState createState() => _GoalProgressBoxState(goal);
}

class _GoalProgressBoxState extends State<GoalProgressBox> {
  _GoalProgressBoxState(this.goal);

  final GoalModel goal;
  String progressString = "";
  double percent = 0;
  int current = 0;
  int target = 0;

  @override
  void initState() {
    super.initState();
    current = goal.currentAmount;
    target = goal.targetAmount;
    percent = (100 * goal.currentAmount) / goal.targetAmount;
    progressString = "$percent%";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.black,
            width: 3,
          )),
      child: Column(children: [
        Text(
          "Progress so far",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        Text(
          "$progressString or £$current of £$target",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
      ]),
    );
  }
}
