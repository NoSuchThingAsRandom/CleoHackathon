import 'dart:collection';

import 'package:flutter/cupertino.dart';

class Message {
  /// The text to display for this message
  final String content;

  /// Whether the message sender is cleo, or the user
  final bool isCleo;

  Message(this.content, this.isCleo);
}

//https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#changenotifier
class ChatBackend extends ChangeNotifier {
  /// Internal, private state of the cart.
  // TODO Create better messages
  List<Message> _messages = [
    Message("Hello", false),
    Message("How are you?", true),
  ];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Message> get messages => UnmodifiableListView(_messages);

  /// Adds [message] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Message message) {
    _messages.add(message);
    _messages.add(Message("Some cool response", true));
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _messages.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
