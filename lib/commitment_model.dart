/// The item that is given up to achieve an item
class CommitmentModel {
  int targetAmount;

  /// Stores days and whether the commitment was successful on that day (true)
  Map<String, bool> successfulDays;

  CommitmentModel(this.targetAmount, this.successfulDays);
}
