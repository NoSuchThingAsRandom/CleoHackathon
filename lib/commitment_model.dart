import 'dart:collection';

/// The item that is given up to achieve an item
class CommitmentModel {
  String name;
  int targetAmount;

  /// Stores days and whether the commitment was successful on that day (true)
  Map<String, bool> successfulDays;

  CommitmentModel(this.name, this.targetAmount, this.successfulDays);

  CommitmentModel.templateOne()
      : this.name = "Give up coffee",
        this.targetAmount = 5,
        this.successfulDays = LinkedHashMap();

  CommitmentModel.templateTwo()
      : this.name = "Give up coffee",
        this.targetAmount = 5,
        this.successfulDays = LinkedHashMap.from({"today": true});

  CommitmentModel.templateThree()
      : this.name = "Give up coffee",
        this.targetAmount = 5,
        this.successfulDays = LinkedHashMap.from({"today": false});
}
