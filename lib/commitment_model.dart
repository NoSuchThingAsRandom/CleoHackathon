import 'dart:collection';

/// The item that is given up to achieve an item
class CommitmentModel {
  String name;
  int targetAmount;

  /// Stores days and whether the commitment was successful on that day (true)
  Map<String, bool> successfulDays;

  CommitmentModel(this.name, this.targetAmount, this.successfulDays);

  CommitmentModel.noDrinksOnFriday()
      : this.name = "No Drinks on friday",
        this.targetAmount = 10,
        this.successfulDays = LinkedHashMap();

  CommitmentModel.starbucks()
      : this.name = "Give up going to starbucks :(",
        this.targetAmount = 5,
        this.successfulDays = LinkedHashMap.from({"0": true});

  CommitmentModel.walking()
      : this.name = "Walk instead of getting the bus",
        this.targetAmount = 2,
        this.successfulDays = LinkedHashMap.from({"0": true});

  CommitmentModel.shopAtAldi()
      : this.name = "Buy everything from Aldi *Shudder*",
        this.targetAmount = 20,
        this.successfulDays = LinkedHashMap.from({"0": true});

  CommitmentModel.greggs()
      : this.name = "Resist the Greggs",
        this.targetAmount = 5,
        this.successfulDays = LinkedHashMap.from({"0": false});

  CommitmentModel.drinkTapWaterInsteadOfBottled()
      : this.name = "Suffer with boring tap water",
        this.targetAmount = 10,
        this.successfulDays = LinkedHashMap.from({"0": true});

  CommitmentModel.noClothesShopping()
      : this.name = "No clothes for me",
        this.targetAmount = 50,
        this.successfulDays = LinkedHashMap.from({"0": true});
}
