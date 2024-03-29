import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/chat_screen_for_learners.dart';
import 'package:expert_ease/Pages/chat_screen_for_tutors.dart';
import 'package:expert_ease/Pages/messages_screen_for_tutors.dart';
import 'package:expert_ease/intro_screens/video_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TutorDetailsLearner extends StatefulWidget {
  final Map<String, dynamic> tutorData;
  TutorDetailsLearner({required this.tutorData});

  @override
  State<TutorDetailsLearner> createState() => _TutorDetailsLearnerState();
}

class _TutorDetailsLearnerState extends State<TutorDetailsLearner> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  List<Map<String, dynamic>> tutors = [];
  String? userName;
  // String? imageUrl;
  String? imageTutorUrl;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    // Retrieve the user's name from the 'userNewProfile' collection
    _firestore
        .collection('userNewProfile')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['name'];
          // imageUrl = snapshot.data()?['profileImage'];
          loadTutors();
        });
      }
    });
  }

  Future<void> loadTutors() async {
    final QuerySnapshot tutorSnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'Tutor')
        .get();

    for (final doc in tutorSnapshot.docs) {
      final Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

      if (docData != null) {
        final tutorUID = docData['uid'];

        if (tutorUID != null) {
          final tutorSubjectSnapshot =
              await _firestore.collection('userNewProfile').doc(tutorUID).get();

          final Map<String, dynamic>? tutorSubjectData =
              tutorSubjectSnapshot.data() as Map<String, dynamic>?;

          if (tutorSubjectData != null) {
            final tutorName = tutorSubjectData['name'];
            final tutorSubject = tutorSubjectData['subject'];
            final tutorBio = tutorSubjectData['bio'];
            final tutorLocation = tutorSubjectData['address'];
            imageTutorUrl = tutorSubjectSnapshot.data()?['profileImage'];

            // Do something with tutorEmail and tutorSubject
            print('Tutor Name: $tutorName, Tutor Subject: $tutorSubject');

            setState(() {
              tutors.add({
                'name': tutorName,
                'subject': tutorSubject,
                'bio': tutorBio,
                'address': tutorLocation,
                // 'profileImage': imageUrl,
                'uid': tutorUID,
                'profileImage': imageTutorUrl,
              });
            });
          }
        }
      }
    }
  }

  List imgs = [
    "tutor1.jpeg",
    "tutor2.jpeg",
    "tutor3.jpeg",
    "tutor4.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7165D6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: "${widget.tutorData['profileImage']}" != null
                                ? NetworkImage("${widget.tutorData['profileImage']}")
                                : AssetImage("images/default_avatar.png")
                                    as ImageProvider<Object>?,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "${widget.tutorData['name']}",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${widget.tutorData['subject']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF9F97E2),
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreenForLearner(receiverUserEmail: widget.tutorData['name'],
                receiverUserID:widget.tutorData['uid'],)));},
                                  child: Icon(
                                    CupertinoIcons.chat_bubble_text_fill,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 20,
                left: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "About Tutor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${widget.tutorData['bio']}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
             
                  SizedBox(height: 10),
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFF0EEFA), shape: BoxShape.circle),
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFF7165D6),
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "${widget.tutorData['address']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("address line of the tutor,"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(15),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return VideoList();
                  }),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF7165D6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Recorded Free Sessions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
