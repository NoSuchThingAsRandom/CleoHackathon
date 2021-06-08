import 'dart:collection';

import 'commitment_model.dart';

class GoalModel {
  String name;
  String description;
  DateTime targetDate;
  int targetAmount;
  int currentAmount;
  LinkedHashSet<CommitmentModel> commitments;

  GoalModel(this.name, this.description, this.targetDate, this.targetAmount,
      this.currentAmount)
      : this.commitments = LinkedHashSet();

  GoalModel.newGoal(this.name, this.description, this.targetDate,
      this.targetAmount, this.currentAmount, this.commitments);

  GoalModel.templateOne()
      : this.name = "Goal Template1",
        this.description = "Some long boring description1",
        this.targetDate = DateTime.now(),
        this.targetAmount = 100,
        this.currentAmount = 1,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.templateOne(),
          CommitmentModel.templateTwo(),
          CommitmentModel.templateThree()
        ]);

  GoalModel.templateTwo()
      : this.name = "Goal Template2",
        this.description = "Some long boring description2",
        this.targetDate = DateTime.now(),
        this.targetAmount = 200,
        this.currentAmount = 2,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.templateOne(),
          CommitmentModel.templateTwo(),
          CommitmentModel.templateThree()
        ]);

  GoalModel.templateThree()
      : this.name = "Goal Template3",
        this.description = "Some long boring description3",
        this.targetDate = DateTime.now(),
        this.targetAmount = 300,
        this.currentAmount = 3,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.templateOne(),
          CommitmentModel.templateTwo(),
          CommitmentModel.templateThree()
        ]);
}
