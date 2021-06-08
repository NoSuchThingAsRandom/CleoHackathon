import 'package:flutter/material.dart';
import 'package:goal_view/cleo_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart';
import 'goal_model.dart';
import 'commitment_model.dart';

void main() {
  DateTime date = DateTime.utc(2021,6,9);
  Map<String, bool> days = {"1":true,"2":false,"3":true};
  Set<CommitmentModel> commitments ={CommitmentModel("first", 5, days)};
  GoalModel goal = GoalModel("test", "this is a test", date,100, 30, commitments);
  runApp(App(goal));
}

class App extends StatelessWidget {
  App(this.goal);
  final GoalModel goal;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Your Goals',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primarySwatch: Data.material_cleo_blue,
        accentColor: Data.material_cleo_blue_tint_3,
        scaffoldBackgroundColor: Data.material_cleo_blue_tint_3,
        textTheme: GoogleFonts.archivoTextTheme()),
      home: Goals(goal),
    );
  }
}

class Goals extends StatelessWidget {
  Goals(this.goal);
  final GoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CleoAppBar(),
      body: Column(
        children: [
          Text("The goal: "+goal.name, style: Theme.of(context).textTheme.headline1),
          GoalProgressBar(goal),
          GoalDescription(goal),
          GoalDates(goal),
          CommitmentList(goal),
        ]
      )
    );
  }
}

class CommitmentList extends StatefulWidget{
  CommitmentList(this.goal);
  final GoalModel goal;
  @override
  _CommitmentListState createState() => _CommitmentListState(goal);
}

class _CommitmentListState extends State<CommitmentList> {
  
  _CommitmentListState(this.goal);
  final GoalModel goal;
  final List<String> commitments = <String>["first"];
  final List<int> ammounts = <int>[5];
  
  // @override
  // void initState(){
  //   super.initState();
  //   for(CommitmentModel commitment in goal.commitments) {
  //     commitments.add(commitment.name);
  //     ammounts.add(commitment.targetAmount);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("See your commits"),
          ListView.builder(
            itemCount: commitments.length,
            itemBuilder: (BuildContext context, int index){
              return Text("${commitments[index]} ${ammounts[index]}");
            }
      ),
      ]
    ),
    );
  }
}

class GoalDates extends StatelessWidget {
  GoalDates(this.goal);
  final GoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Container (
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          GoalFinishDate(goal.targetDate),
          GoalExpectedDate(goal),
        ]
        ),
    );
  }
}
class GoalFinishDate extends StatelessWidget{
  GoalFinishDate(this.goalDate);
  final DateTime goalDate;
  @override
  Widget build(BuildContext context) {
    return Container (
      height: 200,
      width: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.black,
          width: 3,
        )
      ),
      child: Column(
        children: 
        [
          Text("Target Date", style: 
            TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          Text("$goalDate", style: 
            TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
      ]
      ),
    );
  }
}

class GoalExpectedDate extends StatefulWidget{
  GoalExpectedDate(this.goal);
  final GoalModel goal;
  @override
  _GoalExpectedDateState createState() => _GoalExpectedDateState(goal);
}

class _GoalExpectedDateState extends State<GoalExpectedDate> {
  _GoalExpectedDateState(this.goal);
  final GoalModel goal;
  double daysToGo = 0;

  double _daysToGo(goal){
    var remains = (goal.targetAmount - goal.currentAmount);
    var save = 0;
    for (CommitmentModel commit in goal.commitments) {
      save += commit.targetAmount;
    }
    var days = remains / save;
    return days.ceil();
  }
  @override
  void initState() {
    super.initState();
    daysToGo = _daysToGo(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 150,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.black,
          width: 3,
        )
      ),
      child: Column(
        children: 
        [
          Text("Expected Date to finish", style: 
            TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Text("$daysToGo", style: 
            TextStyle(
              color: Colors.white,
              fontSize: 72,
            ),
          ),
      ]
      ),
    );
  }
}

class GoalDescription extends StatelessWidget {
  GoalDescription(this.goal);
  final GoalModel goal;
  @override 
  Widget build(BuildContext context) {
    return Text("Description: " + goal.description);
  }
}

class GoalProgressBar extends StatefulWidget {
  GoalProgressBar(this.goal);
  final GoalModel goal;
  
  @override
  _GoalProgressBarState createState() => _GoalProgressBarState(goal);
}

class _GoalProgressBarState extends State<GoalProgressBar> {
  _GoalProgressBarState(this.goal);
  final GoalModel goal;
  double _goalProgress = 0;
  String progressString = "";
  double percent = 0;
  
  @override
  void initState(){
    super.initState();
    percent = 100 * goal.currentAmount / goal.targetAmount;
    progressString = percent.toStringAsFixed(1) + "%";
    setState(() {
      _goalProgress = percent;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Your progress " + progressString),
        LinearProgressIndicator(),
    ]
    );
  }
}
