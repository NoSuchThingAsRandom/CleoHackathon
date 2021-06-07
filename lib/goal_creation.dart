import 'package:cleo_hackathon/commitment_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';

class GoalCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GoalCreationState();
}

class GoalCreationState extends State<GoalCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<CommitmentModel> possibleCommitments = [
    CommitmentModel("Starbucks", 50, {}),
    CommitmentModel("Walk instead of bus", 50, {}),
    CommitmentModel("Smiley Faces", 50, {})
  ];
  List<CommitmentModel> selectedCommitments = [];
  DateTime selectedDate = DateTime.now();

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
    List<DropdownMenuItem<CommitmentModel>> commitmentDropdownItems = this
        .possibleCommitments
        .map((commitment) => DropdownMenuItem<CommitmentModel>(
            value: commitment, child: Text(commitment.name)))
        .toList();
    commitmentDropdownItems.add(DropdownMenuItem<CommitmentModel>(
      value: null,
      child: Text("Create new commitment"),
    ));
    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Goal Creation",
                    style: GoogleFonts.archivoBlack(),
                    //TextStyle(fontFamily: "GT-Flexa", color: Data.cleo_blue),
                    textScaleFactor: 1.8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, top: 8),
                          border: UnderlineInputBorder(),
                          hintText: "Bye bye coffee :(",
                          labelText: "Choose a name "),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          border: UnderlineInputBorder(),
                          hintText:
                              "This is a really cool goal, that means I'm gonna give up all my coffee for a month!!!",
                          labelText: "Provide a little description "),
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
                      child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                      onPressed: () => _selectDate(context),
                    ),
                  ])),
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
                            Text("Add Commitment:  "),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: DropdownButton<CommitmentModel>(
                                  value: null,
                                  items: commitmentDropdownItems,
                                  onChanged: (model) {
                                    setState(() {
                                      if (model != null) {
                                        selectedCommitments.add(model);
                                      }
                                    });
                                  },
                                ))
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
                              itemBuilder: (BuildContext context, int index) {
                                CommitmentModel commitmentModel =
                                    selectedCommitments.elementAt(index);
                                return ListTile(
                                  leading: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "NewCommitment");
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
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text("Create!"),
                      onPressed: () {},
                    ),
                  ),
                ])));
  }
}
