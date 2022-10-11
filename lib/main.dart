
import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_login.dart';
import 'package:example/data/models/likes.dart';
import 'package:example/data/models/match.dart';
import 'package:example/data/models/match_message.dart';
import 'package:example/data/models/member.dart';
import 'package:example/services/authentication/auth_service.dart';
import 'package:example/visible/pages/private/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localDbDirectory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(localDbDirectory.path);
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(MatchAdapter());
  Hive.registerAdapter(MatchMessageAdapter());
  Hive.registerAdapter(LikeAdapter());
  await Hive.openBox(HiveBoxes.allMembersBox);
  await Hive.openBox(HiveBoxes.allMembersBox);
  await Hive.openBox(HiveBoxes.matchsBox);
  await Hive.openBox(HiveBoxes.matchMsgBox);
  await Hive.openBox(HiveBoxes.likesBox);

  runApp(
      OverlaySupport.global(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Launcher(),
          )
      )
  );
}

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DbLogin _dbLogin = DbLogin();
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(value: AuthService().user,initialData: null),
        StreamProvider<List<Member>>.value(value: _dbLogin.getListAllMemberStream(), initialData: []),
      ],
      child: Wrapper(),
    );
  }
}