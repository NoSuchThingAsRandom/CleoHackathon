import 'dart:collection';

import 'package:cleo_hackathon/backend.dart';
import 'package:cleo_hackathon/commitment_model.dart';
import 'package:cleo_hackathon/commitment_modification.dart';
import 'package:cleo_hackathon/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'cleo_appbar.dart';
import 'data.dart';

class GoalModification extends StatefulWidget {
  final GoalModel? goal;

  GoalModification(this.goal);

  @override
  State<StatefulWidget> createState() => GoalModificationState();
}

class GoalModificationState extends State<GoalModification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /*
    CommitmentModel("Starbucks", 50, {}),
    CommitmentModel("Walk instead of bus", 50, {}),
    CommitmentModel("Smiley Faces", 50, {})
  ];*/
  List<CommitmentModel> selectedCommitments = [];
  DateTime selectedDate = DateTime.now();
  String newName = "";
  String newDescription = "";
  int targetAmount = 100;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.goal?.targetDate ?? DateTime.now();
  }

  //https://stackoverflow.com/a/52729082
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CleoAppBar(),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.goal == null
                            ? "Goal Creation"
                            : "Goal Modification",
                        style: GoogleFonts.archivoBlack(),
                        textScaleFactor: 1.8,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                        child: TextFormField(
                          initialValue: widget.goal?.name,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8, top: 8),
                              border: UnderlineInputBorder(),
                              hintText: "Save for a new pair of shoes!",
                              labelText: "Choose a name "),
                          onSaved: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              this.newName = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                        child: TextFormField(
                          initialValue: widget.goal?.description,
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 8, top: 8, bottom: 8),
                              border: UnderlineInputBorder(),
                              hintText:
                                  "This is a really cool goal, and I'm gonna give up all my coffee for a month to do it!!!",
                              labelText: "Provide a little description "),
                          onSaved: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              this.newDescription = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                          child: Row(children: [
                        SizedBox(width: 10.0),
                        Text("The target date: "),
                        TextButton(
                          child:
                              Text("${selectedDate.toLocal()}".split(' ')[0]),
                          onPressed: () => _selectDate(context),
                        ),
                      ])),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                        child: TextFormField(
                          initialValue: widget.goal?.targetAmount.toString(),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8, top: 8),
                              border: UnderlineInputBorder(),
                              hintText: "£200",
                              labelText: "Choose a target amount "),
                          onSaved: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              this.targetAmount = int.parse(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Card(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Row(
                              children: [
                                SizedBox(width: 10.0),
                                Text("Add Commitment:  "),
                                temp(context),
                              ],
                            ),
                            Flexible(
                              child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                        color: Data.boss_black,
                                      ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedCommitments.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CommitmentModel commitmentModel =
                                        selectedCommitments.elementAt(index);
                                    return ListTile(
                                      leading: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommitmentModification(
                                                          commitmentModel)));
                                        },
                                      ),
                                      title: Text("${commitmentModel.name}"),
                                      subtitle: Text(
                                          "Amount per day £${commitmentModel.targetAmount}"),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            print("Delete $index");
                                            this
                                                .selectedCommitments
                                                .removeAt(index);
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ])),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                  primary: Data.roast_red)),
                          SizedBox(width: 16),
                          Consumer<Backend>(
                              builder: (context, goalBackend, child) {
                            return ElevatedButton(
                                child: Text(
                                    widget.goal == null ? "Create!" : "Done!"),
                                onPressed: () {
                                  _formKey.currentState?.save();
                                  GoalModel newGoal = GoalModel.newGoal(
                                      newName,
                                      newDescription,
                                      selectedDate,
                                      targetAmount,
                                      0,
                                      LinkedHashSet.from(selectedCommitments));
                                  if (widget.goal == null) {
                                    goalBackend.addGoal(newGoal);
                                  } else {
                                    goalBackend.modifyGoal(
                                        widget.goal!, newGoal);
                                  }
                                  Navigator.pop(context);
                                });
                          })
                        ],
                      ),
                    ]))));
  }

  Widget temp(BuildContext context) {
    final temp = context.watch<Backend>();
    List<DropdownMenuItem<CommitmentModel>> commitmentDropdownItems = temp
        .commitments
        .map((commitment) => DropdownMenuItem<CommitmentModel>(
            value: commitment, child: Text(commitment.name)))
        .toList();
    commitmentDropdownItems.add(DropdownMenuItem<CommitmentModel>(
      value: null,
      child: Text("Create new commitment"),
    ));
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: DropdownButton<CommitmentModel>(
          value: null,
          items: commitmentDropdownItems,
          onChanged: (model) async {
            if (model != null) {
              setState(() {
                selectedCommitments.add(model);
              });
            } else {
              CommitmentModel? newCommitment = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommitmentModification(null)));
              if (newCommitment != null) {
                setState(() {
                  temp.addCommitment(newCommitment);
                  selectedCommitments.add(newCommitment);
                });
              }
            }
          },
        ));
  }
}
