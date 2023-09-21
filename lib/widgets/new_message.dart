import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = new TextEditingController();
  var _enterMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser!;
    final userData =
        FirebaseFirestore.instance.collection('user').doc(user.uid);
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterMessage,
      'createsAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData,
      'image_url': userData
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Send a message',
                ),
                onChanged: (value) {
                  setState(() {
                    _enterMessage = value;
                  });
                }),
          ),
          IconButton(
              color: Colors.pink,
              icon: Icon(Icons.send),
              onPressed: _enterMessage.trim().isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
