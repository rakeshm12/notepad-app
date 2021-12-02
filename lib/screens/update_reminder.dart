import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'card_screen.dart';

Future updateData(BuildContext context, id) async {
  return showDialog(
      context: context,
      builder: (context) {
        final _title = TextEditingController();
        final _subject = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          actionsPadding: EdgeInsets.all(16),
          actions: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  hintText: 'title', hintStyle: TextStyle(color: Colors.grey)),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
                controller: _subject,
                decoration: InputDecoration(
                    hintText: 'subject',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
                style: TextStyle(color: Colors.black)),
            TextButton(
                onPressed: () {

                  if(_title.text.isEmpty || _subject.text.isEmpty){
                    return;
                  }
                  Map<String, dynamic> card = {
                    'title': _title.text,
                    'subject': _subject.text,
                  };
                  final firestore = FirebaseFirestore.instance;
                  final doc = firestore
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('reminders');
                  doc.doc(id).update(card);
                  Fluttertoast.showToast(
                      msg: 'Reminder Updated', toastLength: Toast.LENGTH_SHORT);

                  doc.doc().collection('reminders').get();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardScreen(),
                      ),
                      (route) => false).then(
                    (value) => Navigator.pop(context),
                  );
                },
                child: const Text('Update', style: TextStyle(fontSize: 16),))
          ],
        );
      });
}
