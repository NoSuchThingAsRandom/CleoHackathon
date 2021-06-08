import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import 'commitment_model.dart';
import 'goal_model.dart';

class Message {
  /// The text to display for this message
  final String content;

  /// Whether the message sender is cleo, or the user
  final bool isCleo;

  Message(this.content, this.isCleo);
}

//https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#changenotifier
class ChatBackend extends ChangeNotifier {
  /// Internal, private state of the messages.
  // TODO Create better messages
  List<Message> _messages = [
    Message("Hello", false),
    Message("How are you?", true),
  ];

  /// An unmodifiable view of the messages for consumers
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

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
    if (words.contains("?") && (words.contains("goal"))){ ///basic way to determine whether the user asked for a list of their active goals
      return Message("Forgottten already? \nhere they are:\n", true);///TODO list of all goals on the goals screen. Percentage completed or days followed if commitment
    }
    else if (words.contains("want to")){ /// user wants to create a new goal or start a commitment(simplified for demonstration purposes)
      String kind = ""; ///determines whether it is a commitment or goal that is being made
      String aim = ""; ///the reason for this goal or commitment
      int amount = 0; /// if goal, the monetary target, if commitment, the length of the commitment
      if (words.contains(RegExp(r'for [0-9]* days'))){
        kind = "Commitment";
        String commitmentAim =  words.split("want to").elementAt(1);
        aim = commitmentAim.split("for").elementAt(0);
        amount = int.parse(commitmentAim.split("for").elementAt(1).split("days").elementAt(0));
        String output = "Type: " + kind + "\n" + "Goal: " + aim + "\n" + "Duration: " + amount.toString();
        CommitmentModel newCommitment = CommitmentModel(aim, 0, new Map<String, bool>()); ///TODO add to data store
        return Message(output, true);
      }
      if (words.contains("save")){
        kind = "Goal";
        String goalAim =  words.split("want to save").elementAt(1);
        aim = goalAim.split("for").elementAt(1);
        amount = int.parse(goalAim.split("for").elementAt(0));
        String output = "Type: " + kind + "\n" + "Purpose: " + aim + "\n" + "Value: " + amount.toString();
        GoalModel newGoal = new GoalModel(aim, "", DateTime.now().add(Duration(days: 14)), amount, 0);///TODO add new goal to data store
        return Message(output, true);
      }
    }
    if (words == "roast me"){
      List<String> roasts = [
        "You suck",
        "Look at this looser, asking an app for financial advice",
        "That goal you just set? no way ur achieving that",
        "Nobody likes you",
        "Ive seen babies who are more financially literate",
        "I wish i was a real person so i could walk away from talking to you",
        "*Guy carrying pizza walking into a room gif*",];
      return Message(roasts[Random().nextInt(roasts.length)], true);
    }
    else{
      return Message("i know, right?", true);
    }
  }
}
