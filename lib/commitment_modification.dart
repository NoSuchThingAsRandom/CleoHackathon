import 'package:cleo_hackathon/commitment_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cleo_appbar.dart';
import 'data.dart';

class CommitmentModification extends StatefulWidget {
  final CommitmentModel? state;

  CommitmentModification(this.state);

  @override
  State<StatefulWidget> createState() => CommitmentModificationState();
}

class CommitmentModificationState extends State<CommitmentModification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newName = "";
  int newAmountSaved = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CleoAppBar(),
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      widget.state == null
                          ? "Commitment Creation"
                          : "Commitment Modification",
                      style: GoogleFonts.archivoBlack(),
                      textScaleFactor: 1.8),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: TextFormField(
                      initialValue: widget.state?.name,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8, top: 8),
                          border: UnderlineInputBorder(),
                          hintText: "Quit starbucks",
                          labelText: "Choose a name "),
                      onSaved: (String? value) {
                        print("Saving name: $value");
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
                      initialValue: widget.state != null
                          ? "${widget.state?.targetAmount}"
                          : null,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          border: UnderlineInputBorder(),
                          hintText: "£10",
                          labelText: "How much will it save a day?"),
                      onSaved: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          this.newAmountSaved =
                              int.parse(value); //value as int;
                        }
                      },
                    ),
                  ),
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
                      ElevatedButton(
                          child:
                              Text(widget.state == null ? "Create!" : "Done!"),
                          onPressed: () {
                            _formKey.currentState?.save();
                            print("$newName   $newAmountSaved");

                            Navigator.pop(
                                context,
                                CommitmentModel(
                                    this.newName,
                                    this.newAmountSaved,
                                    widget.state?.successfulDays ?? {}));
                          }
                          // TODO Send new commitment to data store
                          ),
                    ],
                  ),
                ])));
  }
}
