import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_likes.dart';
import 'package:example/data/database/online/db_match.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/private/navigationsScreens/selectedMemberProfil.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class PlayMatch extends StatefulWidget {
  final String? uid;
  PlayMatch({required this.uid});

  @override
  State<PlayMatch> createState() => _PlayMatchState();
}

class _PlayMatchState extends State<PlayMatch> {
  final CollectionReference likesRef = FirebaseFirestore.instance.collection('likes');
  final DbMatch _dbMatch = DbMatch();
  final DbLikes _dbLikes = DbLikes();
  int index = 0;
  bool currentUserIsLiked=false;
  bool likeButtonClicked = false;
  bool disLikeButtonClicked = false;
  Stream? currentUserLikes;
  Member? currentUser;

  @override
  void initState() {
    super.initState();
    currentUserLikes =Collections.likes.doc(widget.uid).collection(Collections.likesList).snapshots();
  }

  Future<bool> isCurrentUserLikedBySelectedUser({String? selectedUserId})async{
    DocumentSnapshot doc = await Collections.likes.doc(selectedUserId).collection(Collections.likesList).doc(widget.uid).get();
    if(doc.exists){
      setState(() {
        currentUserIsLiked = doc['likeValue'];
      });
    }
    return currentUserIsLiked;
  }

  Future loadingMemberStreamInLocalDb(List<Member> listAllMembers)async{
    await Hive.openBox(HiveBoxes.allMembersBox);
    await Hive.box(HiveBoxes.allMembersBox).clear();
    await Hive.box(HiveBoxes.allMembersBox).addAll(listAllMembers);
  }

  Future loadingCurrentUserLikesStreamInLocalDb(List<Like> currentUserLikesList)async{
    await Hive.openBox(HiveBoxes.likesBox);
    await Hive.box(HiveBoxes.likesBox).clear();
    await Hive.box(HiveBoxes.likesBox).addAll(currentUserLikesList);
  }

  @override
  Widget build(BuildContext context){
    final currentUserLikesList = Provider.of<List<Like>>(context);
    loadingCurrentUserLikesStreamInLocalDb(currentUserLikesList);
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
        builder: (context,box,_){
          var listOfAllMembers = box.values.toList().cast<Member>();
          return ValueListenableBuilder<Box>(
              valueListenable: Hive.box(HiveBoxes.likesBox).listenable(),
              builder: (context,box,_){
                var currentUserLikesList = box.values.toList().cast<Like>();

                List<String?> likeIdList = [];
                List<Member> membersNotLikedList = [];
                likeIdList.clear();
                currentUserLikesList.forEach((like) {
                  likeIdList.add(like.uid);
                });

                membersNotLikedList.clear();
                listOfAllMembers.forEach((member) {
                  if(!likeIdList.contains(member.uid) && widget.uid!=member.uid){
                    membersNotLikedList.add(member);
                  }else if(member.uid == widget.uid){
                    currentUser = member;
                  }
                });

                Iterator iterator = membersNotLikedList.iterator;
                return membersNotLikedList.isNotEmpty
                    ? SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(membersNotLikedList[index].profilImage.toString()),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5),
                              FloatingActionButton.extended(
                                onPressed: () {},
                                backgroundColor: Colors.lightGreen,
                                label: Text(
                                    "${membersNotLikedList[index].username}"),
                              ),
                              const SizedBox(width: 5),
                              FloatingActionButton.extended(
                                onPressed: () {},
                                backgroundColor: Colors.lightGreen,
                                heroTag: null,
                                label:
                                Text("${membersNotLikedList[index].age}"),
                              ),
                              const SizedBox(width: 5),
                              membersNotLikedList[index].town != ""
                                  ? FloatingActionButton.extended(
                                onPressed: () {},
                                heroTag: null,
                                backgroundColor:
                                Colors.lightGreen,
                                label: Text(
                                    "${membersNotLikedList[index].town}"),
                              )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all( Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor:Colors.transparent,
                                  radius: 40,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.clear, size: 40,color: Colors.red),
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (currentUser?.profilVerified == false) {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    "Du kannst Mitglieder erst disliken, wenn Dein Profil verifiziert ist!"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                        "Verstanden"),
                                                    onPressed: () =>
                                                        Navigator.of(
                                                            context)
                                                            .pop(),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else {
                                        iterator.moveNext();
                                       await _dbLikes.setLikesData(
                                            currentUserId: widget.uid,
                                            selectedUserId: membersNotLikedList[index].uid,
                                            likeValue: false);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 40,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon:
                                    const Icon(Icons.person, size: 40),
                                    color: Colors.white,
                                    onPressed: () async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedMemberProfil(membersNotLikedList[index])));
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all( Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.lightGreen,
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor:likeButtonClicked?Colors.white:Colors.transparent,
                                  radius: 40,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.check, size: 40,color:Colors.lightGreen),
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (currentUser?.profilVerified == false) {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                content: const Text(
                                                    "Du kannst Mitglieder erst liken, wenn Dein Profil verifiziert ist!"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                        "Verstanden"),
                                                    onPressed: () =>
                                                        Navigator.of(
                                                            context)
                                                            .pop(),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else {
                                        var likeExist = await isCurrentUserLikedBySelectedUser(selectedUserId: membersNotLikedList[index].uid);
                                        if(likeExist){
                                          await _dbMatch.setMatch(currentUser: currentUser,selectedUser: membersNotLikedList[index]);
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                    "Gratuliere, ihr habt ein Match",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.lightGreen,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                          radius: 70.0,
                                                          backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              membersNotLikedList[index].profilImage!),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                        CircleAvatar(
                                                          radius: 70.0,
                                                          backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              "${currentUser?.profilImage}"),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 30,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        TextButton(
                                                          child:
                                                          const Text("verstanden"),
                                                          onPressed: () async {
                                                            iterator.moveNext();
                                                            await _dbLikes.setLikesData(currentUserId: widget.uid, selectedUserId: membersNotLikedList[index].uid,likeValue: true);
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                        }else{
                                          iterator.moveNext();
                                          await _dbLikes.setLikesData(currentUserId: widget.uid, selectedUserId: membersNotLikedList[index].uid,likeValue: true);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                )
                    :  const Center(child: Text("Keine weiteren Vorschläge vorhanden"),
                );
              }
          );
        }
    );

  }
}
