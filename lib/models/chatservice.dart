import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelli_ca/models/message.dart';

class Chatservice {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get User Stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String recieverEmail, message) async {
    // get current user info
    //final String currentUserID = _auth.currentUser!.email;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        //senderID: currentUserID,
        senderEmail: currentUserEmail,
        recieverEmail: recieverEmail,
        message: message,
        timestamp: timestamp);

    //constructing chat room ids for two users (sorted to ensure uniqueness)

    List<String> ids = [currentUserEmail, recieverEmail];
    ids.sort(); // sort the ids { this ensure the chat room id is same for any two people }
    String chatRoomID = ids.join('_');

    // add new messages to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }
  //Get messages

  Stream<QuerySnapshot> getMessages(String userEmail, otheruserEmail) {
    List<String> ids = [userEmail, otheruserEmail];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<String> fetchLatestMessage(String userEmail, otheruserEmail) async {
    List<String> ids = [userEmail, otheruserEmail];
    ids.sort();
    String chatRoomID = ids.join('_');
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['message'];
      } else {
        return '0';
      }
    } catch (e) {
      print('Error fetching latest message: $e');
      return '0';
    }
  }

  //Delete Message
  Future<void> deleteMessages(String userEmail, otheruserEmail, docID) async {
    List<String> ids = [userEmail, otheruserEmail];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(docID)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }
}
