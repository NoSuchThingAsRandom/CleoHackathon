import 'package:flutter/material.dart';

import 'data.dart';

class Message {
  /// The text to display for this message
  final String content;

  /// Whether the message sender is cleo, or the user
  final bool isCleo;

  Message(this.content, this.isCleo);
}

// Useful: https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/
class ChatPage extends StatelessWidget {
  // TODO Create better messages
  final messages = [
    Message("Hello", false),
    Message("How are you?", true),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      /// Builds and displays the messages
      ListView.builder(
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatMessage(messages[index]);
          }),

      /// Builds the keyboard entry
      Align(
          alignment: Alignment.bottomLeft,
          child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Data.paper_white,
                  ),
                  child: Row(children: <Widget>[

                    /// This is placeholder for the feature suggestion
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Data.cleo_blue_tint_2,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: Data.paper_white,
                          size: 20,
                        ),
                      ),
                    ),

                    /// Padding
                    SizedBox(
                      width: 15,
                    ),

                    /// Builds the keyboard entry
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Say something...",
                            hintStyle: TextStyle(color: Data.boss_black_tint_2),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),

                    /// Submit button, could technically remove it?
                    FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    color: Data.paper_white,
                    size: 18,
                  ),
                  backgroundColor: Data.cleo_blue_tint_2,
                  elevation: 0,
                ),
              ]))),
    ]);
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;

  ChatMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
            alignment: message.isCleo ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (message.isCleo ? Data.paper_white : Data.cleo_blue),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message.content,
                style: TextStyle(
                    fontSize: 15,
                    color: message.isCleo ? Data.boss_black : Data.paper_white),
              ),
            )));
  }
}
