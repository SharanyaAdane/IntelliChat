import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intelli_ca/Addons/chat_bubble.dart';
import 'package:intelli_ca/models/auth_gate.dart';
import 'package:intelli_ca/models/chatservice.dart';
import 'package:intelli_ca/models/smart_rply.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String recieverEmail;

  ChatScreen({
    Key? key,
    required this.recieverEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final Chatservice _chatService = Chatservice();
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<String> _smartReplies = [];

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
    fetchSmartReplies();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverEmail, _messageController.text);
      _messageController.clear();
    }

    fetchSmartReplies();
    scrollDown();
  }

  void fetchSmartReplies() async {
    String senderEmail = getCurrentUser()!.email!;
    String latestMsg = await _chatService.fetchLatestMessage(
        widget.recieverEmail, senderEmail);
    if (latestMsg != '0') {
      List<String> replies =
          await GenerateSmartReply().generateReply(latestMsg);
      //print(replies[0]);
      setState(() {
        _smartReplies = replies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recieverEmail,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
            icon: Icon(
              Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        _buildSmartReplies(),
        _buildUserInput(),
      ]),
    );
  }

  Widget _buildMessageList() {
    String? senderEmail = getCurrentUser()!.email;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverEmail, senderEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    String? senderEmail = getCurrentUser()!.email;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data["senderEmail"] == getCurrentUser()!.email;
    DateTime timeMsg = data["timestamp"].toDate();
    String formattedTime = DateFormat('MMM d, h:mm a').format(timeMsg);
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return InkWell(
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], iscurrentUser: isCurrentUser),
            timeBubble(time: formattedTime),
          ],
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Manage Message',
                style: TextStyle(color: Color.fromARGB(226, 33, 82, 113)),
              ),
              content: Text('Do you want to delete the message '),
              actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Delete Message'),
                  onPressed: () {
                    isCurrentUser
                        ? _chatService.deleteMessages(
                            widget.recieverEmail, senderEmail!, doc.id)
                        : print("Invalid command ");
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSmartReplies() {
    return _smartReplies.isEmpty
        ? SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _smartReplies.map((reply) {
                  return GestureDetector(
                    onTap: () {
                      _messageController.text = reply;
                      myFocusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        reply,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            focusNode: myFocusNode,
            decoration: InputDecoration(
              hintText: 'Enter your message...',
              hintStyle: const TextStyle(color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.black54,
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    );
  }
}
