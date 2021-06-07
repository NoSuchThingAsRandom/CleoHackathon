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
    return Message("Some cool response", true);
  }
}
