import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/chat_screen_for_learners.dart';
import 'package:expert_ease/Pages/chat_screen_for_tutors.dart';
import 'package:expert_ease/Pages/tut_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageScreenForTutors extends StatefulWidget {
  @override
  State<MessageScreenForTutors> createState() => _MessageScreenForTutorsState();
}
 
class _MessageScreenForTutorsState extends State<MessageScreenForTutors> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _userStream;
  @override
  void initState() {
    super.initState();
    _userStream =
        FirebaseFirestore.instance.collection('userLearnerProfile').snapshots();
  }

  List imgs = [
    "tutor1.jpeg",
    "tutor2.jpeg",
    "tutor3.jpeg",
    "tutor4.jpeg",
    "tutor1.jpeg",
    "tutor2.jpeg",
    "tutor3.jpeg",
    "tutor4.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDEBFF),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => tutScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildUserList()),
          ],
        ));
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _userStream = FirebaseFirestore.instance
            .collection('userLearnerProfile')
            .snapshots();
      } else {
        _userStream = FirebaseFirestore.instance
            .collection('userLearnerProfile')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: query + 'z')
            .snapshots();
      }
    });
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['name']) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreenForTutors(
                        receiverUserEmail: data['name'],
                        receiverUserID: data['uid'],
                      )));
        },
        // Newly add code for Image binding
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: data['profileImage'] != null
              ? NetworkImage(data['profileImage'])
              : NetworkImage(
                  'https://png.pngitem.com/pimgs/s/421-4212266_transparent-default-avatar-png-default-avatar-images-png.png'),
        ),
        title: Text(
          data['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Hi,hello",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          "12:30",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
