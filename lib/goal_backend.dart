import 'dart:collection';

import 'package:cleo_hackathon/commitment_model.dart';
import 'package:cleo_hackathon/goal_model.dart';
import 'package:flutter/material.dart';

class GoalBackend extends ChangeNotifier {
  GoalBackend() {
    _goals.add(GoalModel.templateOne());
    _goals.add(GoalModel.templateTwo());
    _goals.add(GoalModel.templateThree());
  }

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
}
