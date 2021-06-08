import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'backend.dart';
import 'data.dart';

// Useful: https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple provider for storing messages
    // https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#changenotifier
    return _ChatPage();
  }
}

class _ChatPage extends StatefulWidget {
  const _ChatPage({Key? key}) : super(key: key);

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      /// Builds and displays the messages
      Consumer<Backend>(builder: (context, Backend, child) {
        return ListView.builder(
            itemCount: Backend.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return ChatMessage(Backend.messages.elementAt(index));
            });
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
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: "Say something...",
                        hintStyle: TextStyle(color: Data.boss_black_tint_2),
                        border: InputBorder.none),
                    onSubmitted: (value) {
                      print("Adding message ${controller.text}");
                      Provider.of<Backend>(context, listen: false)
                          .add(Message(controller.text, false));
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),

                /// Submit button, could technically remove it?
                Consumer<Backend>(
                  builder: (context, Backend, child) {
                    return FloatingActionButton(
                      onPressed: () {
                        print("Adding message ${controller.text}");
                        Backend.add(Message(controller.text, false));
                      },
                      child: Icon(
                        Icons.send,
                        color: Data.paper_white,
                        size: 18,
                      ),
                      backgroundColor: Data.cleo_blue_tint_2,
                      elevation: 0,
                    );
                  },
                )
              ]))),
    ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
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
