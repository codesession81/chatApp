import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_likes.dart';
import 'package:example/data/database/online/db_match.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/widgets/loading/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SelectedMemberProfil extends StatefulWidget {
  final Member selectedUser;
  SelectedMemberProfil(this.selectedUser);

  @override
  _SelectedMemberProfilState createState() => _SelectedMemberProfilState();
}

class _SelectedMemberProfilState extends State<SelectedMemberProfil> {
  final panelController = PanelController();
  bool matchAlreadyExists = false;
  double height = 200;
  String? urlImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Profil von ${widget.selectedUser.username}",
          style: const TextStyle(fontSize: 20, color: Colors.lightGreen),
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: MediaQuery.of(context).size.height * 0.20,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        parallaxEnabled: true,
        parallaxOffset: .5,
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: height,
                          child: CachedNetworkImage(
                            imageUrl: "${widget.selectedUser.profilImage}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Loading(),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 150,
                                )),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
        panelBuilder: (controller) => ProfilSliderWidget(
            controller: controller,
            selectedUser: widget.selectedUser,
            panelController: panelController),
      ),
    );
  }
}

class ProfilSliderWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Member selectedUser;

  ProfilSliderWidget({required this.controller, required this.selectedUser, required this.panelController});

  @override
  State<ProfilSliderWidget> createState() => _ProfilSliderWidgetState();
}

class _ProfilSliderWidgetState extends State<ProfilSliderWidget> {
  final DbLikes _dbLikes = DbLikes();
  final DbMatch _dbMatch = DbMatch();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  num? selectedUserMatchCounter;
  Member? currentUser;
  Member? selectedUser;
  User? user;
  bool selectedUserIsLiked=false;
  bool currentUserIsLiked=false;
  bool currentUserIsBlocked=false;
  bool _match = false;
  bool matchAlreadyExists = false;
  Stream? selectedUserLikeValueStream;
  Stream? currentUserBlockedValueStream;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    isCurrentUserLikedBySelectedUser();
    isCurrentUserBlockedBySelectedUser();
  }

  Future isCurrentUserLikedBySelectedUser()async{
    DocumentSnapshot doc = await Collections.likes.doc(widget.selectedUser.uid).collection(Collections.likesList).doc(user?.uid).get();
    if(doc.exists){
      selectedUserLikeValueStream = Collections.likes.doc(widget.selectedUser.uid).collection(Collections.likesList).doc(user?.uid).snapshots();
      selectedUserLikeValueStream?.forEach((element) {
        setState(() {
          currentUserIsLiked = element['likeValue'];
        });
      });
    }
  }

  Future isCurrentUserBlockedBySelectedUser()async{
    DocumentSnapshot doc = await Collections.matchs.doc(widget.selectedUser.uid).collection(Collections.matchLists).doc(user?.uid).get();
    if(doc.exists){
      currentUserBlockedValueStream = Collections.matchs.doc(widget.selectedUser.uid).collection(Collections.matchLists).doc(user?.uid).snapshots();
      currentUserBlockedValueStream?.forEach((element) {
        setState(() {
          currentUserIsBlocked = element['blocked'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
        builder: (context,box,_){
          var allMembers = box.values.toList().cast<Member>();
          return ValueListenableBuilder<Box>(
              valueListenable: Hive.box(HiveBoxes.likesBox).listenable(),
              builder: (context,box,_){
                var currentUserLikes = box.values.toList().cast<Like>();
                return ValueListenableBuilder<Box>(
                    valueListenable: Hive.box(HiveBoxes.matchsBox).listenable(),
                    builder: (context,box,_){
                      var currentUserMatchs = box.values.toList().cast<Match>();

                      isCurrentUserLikedBySelectedUser();
                      isCurrentUserBlockedBySelectedUser();

                      allMembers.forEach((member) {
                        if(member.uid == user?.uid){
                          currentUser = member;
                        }
                      });

                      currentUserLikes.forEach((member) {
                        if(member.uid == widget.selectedUser.uid){
                          if(member.likeValue==true){
                            selectedUserIsLiked = true;
                          }
                        }
                      });

                      currentUserMatchs.forEach((match) {
                        if(match.uid == widget.selectedUser.uid){
                          matchAlreadyExists=true;
                        }
                      });

                      if(selectedUserIsLiked && currentUserIsLiked){
                        _match = true;
                      }

                      if(_match && !matchAlreadyExists){
                         _dbMatch.setMatch(selectedUser: widget.selectedUser,currentUser: currentUser);
                      }

                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            controller: widget.controller,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                      heroTag: null,
                                      onPressed: () {},
                                      backgroundColor: widget.selectedUser.profilVerified == false
                                          ? Colors.red
                                          : Colors.green,
                                      label: widget.selectedUser.profilVerified == false
                                          ? const Text("Profil nicht verifiziert")
                                          : const Text("Profil verifiziert"),
                                    ),

                                    _match?FloatingActionButton.extended(
                                        heroTag: null,
                                        onPressed: () {},
                                        backgroundColor: Colors.white,
                                        label:Row(
                                          children:<Widget>[
                                            currentUserIsBlocked?Container():const Icon(Icons.favorite, color: Colors.red),
                                            const SizedBox(width: 5),
                                            currentUserIsBlocked?const Text("Geblocked", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)):const Text("Match", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                          ],
                                        )):FloatingActionButton.extended(
                                        heroTag: null,
                                        onPressed: () async {
                                          if (currentUser?.profilVerified == false) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const Text(
                                                        "Du kannst Mitglieder erst liken, wenn Dein Profil verifiziert ist!"),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text("Verstanden"),
                                                        onPressed: () =>
                                                            Navigator.of(context).pop(),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            _dbLikes.setLikesData(currentUserId: currentUser?.uid,selectedUserId: widget.selectedUser.uid,likeValue: true);
                                            setState(() {});
                                          }
                                        },
                                        backgroundColor: selectedUserIsLiked
                                            ? Colors.red
                                            : Colors.lightGreen,
                                        label: selectedUserIsLiked
                                            ? const Text("Liked")
                                            : const Text("Like")),
                                  ],
                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
          );
        }
    );
  }
}
