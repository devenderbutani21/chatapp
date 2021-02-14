import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  Stream userStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchButtonClick() async {
    isSearching = true;
    setState(() {});
    userStream = await DatabaseMethods()
        .getUserByUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget searchListUserTile() {

  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ;
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget chatRoomList() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Clone'),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          searchUsernameEditingController.text = "";
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                          ),
                          child: Icon(Icons.arrow_back),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.4,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchUsernameEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "username",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (searchUsernameEditingController.text != "") {
                              onSearchButtonClick();
                            }
                          },
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomList(),
          ],
        ),
      ),
    );
  }
}
