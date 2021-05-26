import 'package:Canny/Services/auth_comment.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CommentDetail extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final dbRef = FirebaseFirestore.instance.collection("Forum");
  final dbCommentRef = FirebaseFirestore.instance.collection("ForumComment");
  final String inputId;

  CommentDetail(this.inputId);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColour,
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: dbCommentRef.doc(inputId).collection("Comment").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final nameInputController = TextEditingController(text: snapshot.data.docs[index]["name"]);
                      final descriptionInputController = TextEditingController(text: snapshot.data.docs[index]["description"]);
                      int noOfLikes = snapshot.data.docs[index]["likes"];
                      // int noOfDislikes = snapshot.data.docs[index]["dislikes"];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Card(
                                elevation: 9,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                        contentPadding: EdgeInsets.all(18.0),
                                        title: Text(snapshot.data.docs[index]["name"]),
                                        subtitle: Text(
                                            snapshot.data.docs[index]["description"].length > 200
                                                ? snapshot.data.docs[index]["description"].substring(0, 200) + "..."
                                                : snapshot.data.docs[index]["description"]
                                        ),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          child: Text(snapshot.data.docs[index]["name"][0]),
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(DateFormat("EEEE, d MMMM y")
                                              .format(DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data.docs[index]["timestamp"].seconds * 1000)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                                snapshot.data.docs[index]["liked"]
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: snapshot.data.docs[index]["liked"]
                                                    ? Colors.red
                                                    : Colors.black),
                                            onPressed: () {
                                              if (snapshot.data.docs[index]["liked"]) {
                                                dbCommentRef
                                                    .doc(inputId)
                                                    .collection("Comment")
                                                    .doc(snapshot.data.docs[index].id)
                                                    .update({
                                                  "likes": noOfLikes -= 1,
                                                  "liked": false,
                                                }).catchError((error) => print(error));
                                              } else {
                                                dbCommentRef
                                                    .doc(inputId)
                                                    .collection("Comment")
                                                    .doc(snapshot.data.docs[index].id)
                                                    .update({
                                                  "likes": noOfLikes += 1,
                                                  "liked": true,
                                                }).catchError((error) => print(error));
                                              }
                                            },
                                          ),
                                          SizedBox(width: 140.0),
                                          if (snapshot.data.docs[index]["uid"] == uid)
                                            IconButton(
                                              icon:
                                              Icon(FontAwesomeIcons.edit),
                                              onPressed: () async {
                                                await AuthCommentService(inputId).updateComment(
                                                    nameInputController,
                                                    descriptionInputController,
                                                    context,
                                                    snapshot,
                                                    index);
                                              },
                                            ),
                                          SizedBox(width: 10.0),
                                          if (snapshot.data.docs[index]["uid"] == uid)
                                            IconButton(
                                              icon: Icon(
                                                  FontAwesomeIcons.trashAlt),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Are you sure you want to delete your discussion"),
                                                      content: Text("Once your discussion is deleted, you will not be able to retrieve it back."),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        TextButton(
                                                          child: Text("Yes"),
                                                          onPressed: () async {
                                                            await AuthCommentService(inputId).removeComment(
                                                              snapshot.data.docs[index].id,
                                                            );
                                                            snapshot.data.docs.removeAt(index);
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text("No"),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget> [
                                          SizedBox(width: 18.5),
                                          Text(
                                            noOfLikes.toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}