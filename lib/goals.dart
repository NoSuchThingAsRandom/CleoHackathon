import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'commitment_model.dart';
import 'daily_check_in.dart';
import 'goal_model.dart';
import 'goal_modification.dart';

class Goals extends StatelessWidget {
  Goals(this.goal);

  final GoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(
        "The Goal: " + goal.name,
        style: GoogleFonts.archivoBlack(),
        textScaleFactor: 1.8,
      ),
      Padding(
        padding: EdgeInsets.all(10),
      ),
      GoalGraph(goal),
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
            child: Text("Create Goal"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalModification(null))),
          )),
      Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text("Daily Check in"),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DailyCheckInPage())),
          ))
    ]);
  }
}

class GoalGraph extends StatefulWidget {
  GoalGraph(this.goal);
  final GoalModel goal;
  @override
  _GoalGraphState createState() => _GoalGraphState(goal);
}

class _GoalGraphState extends State<GoalGraph> {
  _GoalGraphState(this.goal);
  final GoalModel goal;
  final dataArray = <FlSpot>[];
  int idx = 0;
  //final commitsDaily = <double>[];
  double sum = 0;
  @override
  void initState(){
    super.initState();
    for (CommitmentModel com in goal.commitments){
      com.successfulDays.forEach((k,v) => v ? sum++: sum);
      sum += sum*com.targetAmount;
    }
    for (var j = 0; j < goal.daysActive; j++){
      dataArray.add(FlSpot(goal.daysActive.toDouble()-j,sum));
      idx = (goal.daysActive-j);
      for (CommitmentModel comit in goal.commitments){
        if(comit.successfulDays.values.elementAt(idx)){
          sum -= comit.targetAmount;
        }
      }
      //final finalDataArray = dataArray.reversed;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.all(5),
              width: 250,
              height: 150,
              child: LineChart(LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataArray,
                     colors: [
                       Colors.blue
                       ],
                      isCurved: true,
                  )
                ],
              ), 
              ),
    );
  }
}

class CommitmentList extends StatefulWidget {
  CommitmentList(this.goal);

  final GoalModel goal;

  @override
  _CommitmentListState createState() => _CommitmentListState(goal);
}

class _CommitmentListState extends State<CommitmentList> {
  _CommitmentListState(this.goal);

  final GoalModel goal;
  final List<String> commitments = <String>[];
  final List<String> ammounts = <String>[];

  @override
  void initState(){
    super.initState();
    for(CommitmentModel commitment in goal.commitments) {
      commitments.add(commitment.name);
      ammounts.add(commitment.targetAmount.toDouble().toStringAsFixed(2));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text("See your commitments (name - cost)", style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      ),
      //some div?
      Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: commitments.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text("${commitments[index]} - £${ammounts[index]} per day", 
                  style: TextStyle(
                    fontSize: 24, 
                  ),
                  textAlign: TextAlign.center,
                ),
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
          child:GoalFinishDate(goal.targetDate),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child:GoalExpectedDate(goal),
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
    return Text("Description: " + goal.description, 
    style: TextStyle(
      fontSize: 16,
    ),
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
      child: Column(
        children:[
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
