import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_login.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/member.dart';
import 'package:example/visible/pages/mainLoginView.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/deleteProfil.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/profilSettings.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/profilVerification.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilUpdate/updateGender.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilUpdate/updateTown.dart';
import 'package:example/visible/widgets/action_button.dart';
import 'package:example/visible/widgets/loading/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final bucketGlobal = PageStorageBucket();

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final panelController = PanelController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  double height = 200;
  Member? currentUser;
  List<Member>? listAllMember;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box>(
       valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
       builder: (context,box,_){
         listAllMember = box.values.toList().cast<Member>();
         listAllMember?.forEach((element) {
           if(element.uid == user?.uid){
             currentUser = element;
           }
         });
         return SlidingUpPanel(
           controller: panelController,
           minHeight: MediaQuery.of(context).size.height * 0.20,
           maxHeight: MediaQuery.of(context).size.height * 0.9,
           parallaxEnabled: true,
           parallaxOffset: .5,
           body: SafeArea(
               child: Column(
                 children: <Widget>[
                   Row(
                     children: [
                       Expanded(
                           child: Stack(
                             children: <Widget>[
                               SizedBox(
                                 height: height,
                                 child: CachedNetworkImage(
                                   imageUrl:
                                   "${currentUser?.profilImage}",
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
               )),
           panelBuilder: (controller) => ProfilSliderWidget(
             controller: controller,
             panelController: panelController,
             currentUser: currentUser,
           ),
         );
       }
      )
    );
  }
}

class ProfilSliderWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  Member? currentUser;

  ProfilSliderWidget(
      {required this.controller,
      required this.panelController,
      required this.currentUser,
      });

  @override
  State<ProfilSliderWidget> createState() => _ProfilSliderWidgetState();
}

class _ProfilSliderWidgetState extends State<ProfilSliderWidget> {
  final DbLogin _dbLogin = DbLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: bucketGlobal,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            key: PageStorageKey<String>('Profil'),
            controller: widget.controller,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 25),
                Text(
                  "Hallo ${GlobalData.currentUser?.username}, das ist dein Profil",
                  style: const TextStyle(fontSize: 20, color: Colors.lightGreen),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: null,
                      onPressed: () {
                        widget.currentUser?.profilVerified == false? Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilVerification(currentUser: widget.currentUser))):Container();
                      },
                      backgroundColor: widget.currentUser?.profilVerified == false
                          ? Colors.red
                          : Colors.lightGreen,
                      label: widget.currentUser?.profilVerified == false
                          ? const Text("verifiziere es jetzt!")
                          : Row(
                        children: const <Widget>[
                          Text("verifiziert"),
                          SizedBox(width: 10),
                          Icon(Icons.check, color: Colors.white)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.lightGreen,
                          radius: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.security, size: 40),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilSettings(),
                                ),
                              );
                            },
                          ),
                        ),
                        const Text("Sicherheit"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Text("Wohnort"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(label: widget.currentUser?.town,color: Colors.lightGreen),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateTown(widget.currentUser),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Text("Geschlecht"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(label: widget.currentUser?.gender,color: Colors.lightGreen),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateGenderState(widget.currentUser),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      const Text("Möchtest Du Dich ausloggen?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Ja,ausloggen"),
                                      onPressed: () async {
                                        //Hive.close();
                                        await _dbLogin.setOnlineStatus(
                                            widget.currentUser?.uid, 'offline');
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const MainLoginView(),
                                          ),(route)=> false
                                        );
                                        await _auth.signOut();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Abbrechen"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              });
                        },
                        backgroundColor: Colors.red,
                        label: const Text("Logout"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const DeleteProfil()));
                        },
                        backgroundColor: Colors.red,
                        label:const Text("Mitgliedschaft endgültig beenden"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
