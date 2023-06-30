import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final medijakveri = MediaQuery.of(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatdocs = snapshot.data!.docs;
        return Container(
          height: medijakveri.size.height * 0.7,
          child: ListView.builder(
            reverse: true,
            itemCount: chatdocs.length,
            itemBuilder: (context, index) => MessageBubble(
              message: chatdocs[index]['text'],
              userName: chatdocs[index]['username'],
              isMe: chatdocs[index]['userId'] == FirebaseAuth.instance.currentUser!.uid ? true : false,
              key: ValueKey(chatdocs[index].id),
            ),
          ),
        );
      },
    );
  }
}
