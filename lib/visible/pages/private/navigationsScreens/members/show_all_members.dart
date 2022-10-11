import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/private/navigationsScreens/selectedMemberProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowAllMembers extends StatefulWidget {
  final List<Member>? memberListNoCurrentUser;
  ShowAllMembers({required this.memberListNoCurrentUser});

  @override
  _ShowAllMembersState createState() => _ShowAllMembersState();
}

class _ShowAllMembersState extends State<ShowAllMembers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? town,gender,searchMinAge,searchMaxAge;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return memberViewManager(widget.memberListNoCurrentUser,user);
  }

  Widget memberViewManager(List<Member>? memberListNoCurrentUser,User? user) {
    if (memberListNoCurrentUser!.isEmpty ) {
      return const Center(
        child: Text("Noch ganz schön leer hier, wie Du aber sehen kannst arbeiten wir nicht mit Fake-Profilen!",textAlign: TextAlign.center),
      );
    }else {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 35),
          itemCount: memberListNoCurrentUser.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SelectedMemberProfil(memberListNoCurrentUser[index]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 2.0, 2.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 130.0,
                      backgroundImage: CachedNetworkImageProvider(
                          memberListNoCurrentUser[index].profilImage!),
                      backgroundColor: Colors.transparent,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Container(
                        child:
                        memberListNoCurrentUser[index].onlineStatus == "online"
                            ? const CircleAvatar(
                          radius: 7.0,
                          backgroundColor: Colors.green,
                        )
                            : const CircleAvatar(
                          radius: 7.0,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: 0,
                      child: Text("${memberListNoCurrentUser[index].username}, ${memberListNoCurrentUser[index].age}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightGreen),),
                    ),
                    Positioned(
                      bottom: -35,
                      left: 0,
                      child: Text("${memberListNoCurrentUser[index].town}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.lightGreen),),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
