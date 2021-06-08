import 'dart:collection';

import 'commitment_model.dart';

class GoalModel {
  String name;
  String description;
  int daysActive;
  DateTime targetDate;
  int targetAmount;
  int currentAmount;
  LinkedHashSet<CommitmentModel> commitments;

  GoalModel(this.name, this.description, this.targetDate, this.targetAmount,
      this.currentAmount)
      : this.commitments = LinkedHashSet(),
        this.daysActive = 1;

  GoalModel.newGoal(this.name, this.description, this.targetDate,
      this.targetAmount, this.currentAmount, this.commitments)
      : this.daysActive = 1;

  GoalModel.templateOne()
      : this.name = "New Dishwasher",
        this.description = "If I can save £300, I can fix my dishwasher!",
        this.targetDate = DateTime.now(),
        this.targetAmount = 200,
        this.currentAmount = 100,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.starbucks(),
          CommitmentModel.walking(),
        ]),
        this.daysActive = 10;

  GoalModel.templateTwo()
      : this.name = "Brum Brum",
        this.description =
            "Save up for a car, so I don't have to suffer on public transport",
        this.targetDate = DateTime.now().add(Duration(days: 50)),
        this.targetAmount = 2000,
        this.currentAmount = 200,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.greggs(),
          CommitmentModel.drinkTapWaterInsteadOfBottled(),
          CommitmentModel.noClothesShopping(),
        ]),
        this.daysActive = 10;

  GoalModel.templateThree()
      : this.name = "Sunny Beach",
        this.description = "I want to go to Spain, and see the sun!",
        this.targetDate = DateTime.now(),
        this.targetAmount = 300,
        this.currentAmount = 3,
        this.commitments = LinkedHashSet.from([
          CommitmentModel.noDrinksOnFriday(),
          CommitmentModel.shopAtAldi(),
        ]),
        this.daysActive = 10;
}
