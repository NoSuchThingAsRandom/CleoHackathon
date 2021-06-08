import 'package:flutter/foundation.dart';

class Transaction {
  var merchant;
  var amount;
  var date;
  var category;

  Transaction(String merchant, double amount, var dateArr) {
    this.merchant = merchant;
    this.amount = amount;
    //dates stored as year, month, day
    this.date = DateTime.utc(dateArr[0], dateArr[1], dateArr[2]);

    this.category = null;
  }
}

void main() {
  loadTransactionDataset();
}

loadTransactionDataset() {
  var transactions = new List.filled(50, new Transaction("", 0, [0, 0, 0]));
  //I'm sorry, the file reading refused to work
  transactions[0] = new Transaction("Tesco", 3, [2021, 4, 11]);
  transactions[1] = new Transaction("Maloney Opticians", 140, [2021, 4, 12]);
  transactions[2] = new Transaction("Amazon", 58, [2021, 4, 12]);
  transactions[3] = new Transaction("VUDU Lounge", 30, [2021, 4, 14]);
  transactions[4] = new Transaction("Circuit Laundry", 5.1, [2021, 4, 16]);
  transactions[5] = new Transaction("Greggs", 4, [2021, 4, 16]);
  transactions[6] = new Transaction("Tesco", 3, [2021, 4, 16]);
  transactions[7] = new Transaction("Levis", 60, [2021, 4, 16]);
  transactions[8] = new Transaction("Amazon", 37, [2021, 4, 17]);
  transactions[9] = new Transaction("Uber", 7, [2021, 4, 17]);
  transactions[10] = new Transaction("Tesco", 28, [2021, 4, 19]);
  transactions[11] = new Transaction("Nisa", 2, [2021, 4, 20]);
  transactions[12] = new Transaction("Greggs", 4.5, [2021, 4, 21]);
  transactions[13] = new Transaction("Aldi", 21, [2021, 4, 21]);
  transactions[14] = new Transaction("Tesco", 3, [2021, 4, 23]);
  transactions[15] = new Transaction("American Airlines", 250, [2021, 4, 23]);
  transactions[16] = new Transaction("John Doe", 5, [2021, 4, 24]);
  transactions[17] = new Transaction("Revolutions", 10, [2021, 4, 25]);
  transactions[18] = new Transaction("Revolutions", 10, [2021, 4, 29]);
  transactions[19] = new Transaction("Tesco", 4, [2021, 5, 1]);
  transactions[20] = new Transaction("AA", 6, [2021, 5, 2]);
  transactions[21] = new Transaction("VUDU Lounge", 30, [2021, 5, 6]);
  transactions[22] = new Transaction("Uber", 7, [2021, 5, 6]);
  transactions[23] = new Transaction("Krispy Kreme", 18, [2021, 5, 8]);
  transactions[24] = new Transaction("Tesco", 4.2, [2021, 5, 11]);
  transactions[25] = new Transaction("Amazon", 12, [2021, 5, 11]);
  transactions[26] = new Transaction("Greggs", 3, [2021, 5, 15]);
  transactions[27] = new Transaction("John Lewis", 35, [2021, 5, 17]);
  transactions[28] = new Transaction("Selfridges", 17, [2021, 5, 22]);
  transactions[29] = new Transaction("First Bus", 10, [2021, 5, 22]);
  transactions[30] = new Transaction("Tesco", 3, [2021, 5, 22]);
  transactions[31] = new Transaction("Robert Smith", 10, [2021, 5, 25]);
  transactions[32] = new Transaction("Circuit Laundry", 5.1, [2021, 5, 27]);
  transactions[33] = new Transaction("Uber", 7, [2021, 5, 27]);
  transactions[34] = new Transaction("Harlands", 480, [2021, 5, 29]);
  transactions[35] = new Transaction("Tesco", 3, [2021, 5, 30]);
  transactions[36] = new Transaction("Apple", 45, [2021, 5, 31]);
  transactions[37] = new Transaction("Nisa", 3.5, [2021, 5, 31]);
  transactions[38] = new Transaction("Subway", 12, [2021, 6, 1]);
  transactions[39] = new Transaction("Amazon", 11, [2021, 6, 1]);
  transactions[40] = new Transaction("Tesco", 4, [2021, 6, 1]);
  transactions[41] = new Transaction("Aldi", 45, [2021, 6, 2]);
  transactions[42] = new Transaction("Tesco", 25, [2021, 6, 2]);
  transactions[43] = new Transaction("AA", 6, [2021, 6, 2]);
  transactions[44] = new Transaction("YUSU", 12.5, [2021, 6, 5]);
  transactions[45] = new Transaction("YUSU", 12.5, [2021, 6, 5]);
  transactions[46] = new Transaction("YUSU", 12.5, [2021, 6, 5]);
  transactions[47] = new Transaction("Tesco", 3, [2021, 6, 7]);
  transactions[48] = new Transaction("VUDU Lounge", 70, [2021, 6, 7]);
  transactions[49] = new Transaction("Amazon", 15, [2021, 6, 7]);

  return (transactions);
}
