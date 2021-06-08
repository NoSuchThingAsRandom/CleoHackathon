import 'dart:collection';
import 'dart:js';
import 'dart:math';

import 'package:cleo_hackathon/commitment_model.dart';
import 'package:cleo_hackathon/goal_model.dart';
import 'package:flutter/material.dart';
import 'daily_check_in.dart';

class Backend extends ChangeNotifier {
  Backend() {
    _goals.add(GoalModel.templateOne());
    _goals.add(GoalModel.templateTwo());
    _goals.add(GoalModel.templateThree());
  }

  /// Internal, private state of the messages.
  List<Message> _messages = [
    Message("Hello", false),
    Message("How are you?", true),
  ];

  /// An unmodifiable view of the messages for consumers
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  List<GoalModel> _goals = [];
  LinkedHashSet<CommitmentModel> _allCommitments = LinkedHashSet();

  LinkedHashSet<CommitmentModel> getAllCommitments() {
    return _goals.fold(LinkedHashSet(), (previousValue, goal) {
      previousValue.addAll(goal.commitments);
      return previousValue;
    });
  }

  /// An unmodifiable view of the messages for consumers
  UnmodifiableListView<GoalModel> get goals => UnmodifiableListView(_goals);

  UnmodifiableListView<CommitmentModel> get commitments =>
      UnmodifiableListView(_allCommitments);

  void addGoal(GoalModel goal) {
    _goals.add(goal);
    _allCommitments.addAll(goal.commitments);
    notifyListeners();
  }

  void addCommitment(CommitmentModel commitmentModel) {
    _allCommitments.add(commitmentModel);
    notifyListeners();
  }

  void modifyGoal(GoalModel oldGoal, GoalModel newGoal) {
    _goals[_goals.indexOf(oldGoal)] = newGoal;
    _allCommitments.removeAll(oldGoal.commitments);
    _allCommitments.addAll(newGoal.commitments);
    notifyListeners();
  }

  void modifyCommitmentForGoal(GoalModel goal, CommitmentModel oldCommitment,
      CommitmentModel newCommitment) {
    int index = _goals.indexOf(goal);
    _goals[index].commitments.remove(oldCommitment);
    _goals[index].commitments.add(newCommitment);

    notifyListeners();
  }

  /// Adds a [Message] to the data store.
  /// And updates all listeners
  void add(Message message) {
    _messages.add(message);
    _messages.add(calculateCleoResponse(message));
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Calculates what cleo should respond to on a given message
  Message calculateCleoResponse(Message message) {
    String words = message.content;
    if (words.contains("checkin")){
      String output = "";
      for (GoalModel goal in _goals){
        output += goal.name +":\n";
            for (CommitmentModel commitment in goal.commitments){
              output += commitment.name + "\n";
            }
            output += "\n";
      }
      return Message("Here is your daily check - in:\n\n" + output, true);
    }
    if (words.contains("?") && (words.contains("goal"))) {///basic way to determine whether the user asked for a list of their active goals
      String output = "";
      for (GoalModel goal in _goals){
        output += (goal.name + ": " + (goal.currentAmount.toString()) + " out of " + (goal.targetAmount.toString()) + "saved" + "\n");
      }
      return Message("Forgottten already? \nHere they are:\n"+output, true);

    } else if (words.contains("want to")) {
      /// user wants to create a new goal or start a commitment(simplified for demonstration purposes)
      String kind = "";

      ///determines whether it is a commitment or goal that is being made
      String aim = "";

      ///the reason for this goal or commitment
      int amount = 0;

      /// if goal, the monetary target, if commitment, the length of the commitment
      if (words.contains(RegExp(r'for [0-9]* days'))) {
        kind = "Commitment";
        String commitmentAim = words.split("want to").elementAt(1);
        aim = commitmentAim.split("for").elementAt(0);
        amount = int.parse(
            commitmentAim.split("for").elementAt(1).split("days").elementAt(0));
        String output = "Type: " +
            kind +
            "\n" +
            "Goal: " +
            aim +
            "\n" +
            "Duration: " +
            amount.toString();
        CommitmentModel newCommitment =
        CommitmentModel(aim, 0, new Map<String, bool>());

        for (GoalModel goal in goals){
          goal.commitments.add(newCommitment);
        }
        return Message("Legendary willpower!\nThe money saved from " +
            aim +
            " will get you those goals in no time!", true);
      }
      if (words.contains("save")) {
        kind = "Goal";
        String goalAim = words.split("want to save").elementAt(1);
        aim = goalAim.split("for").elementAt(1);
        amount = int.parse(goalAim.split("for").elementAt(0).replaceFirst("£", ""));
        String output = "Type: " +
            kind +
            "\n" +
            "Purpose: " +
            aim +
            "\n" +
            "Value: " +
            amount.toString();
        GoalModel newGoal = new GoalModel(
            aim, "", DateTime.now().add(Duration(days: 14)), amount, 0);

        _goals.add(newGoal);
        return Message("Nice job! You added the following goal:\n" +
            output +
            "\nTake a look over on the goal screen to make sure it is correct", true);
      }
    }
    if (words == "roast me") {
      List<String> roasts = [
        "You suck",
        "Look at this looser, asking an app for financial advice",
        "That goal you just set? no way ur achieving that",
        "Nobody likes you",
        "Ive seen babies who are more financially literate",
        "I wish i was a real person so i could walk away from talking to you",
        "*Guy carrying pizza walking into a room on fire gif*",
      ];
      return Message(roasts[Random().nextInt(roasts.length)], true);
    } else {
      return Message("i know, right?", true);
    }
  }
}

class Message {
  /// The text to display for this message
  final String content;

  /// Whether the message sender is cleo, or the user
  final bool isCleo;

  Message(this.content, this.isCleo);
}
