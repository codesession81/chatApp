
import 'package:flutter/material.dart';

import '../widgets/login/bottomNavigationMenu.dart';
import 'login.dart';
import 'registration/setEmailadresse.dart';
import 'requestUserData.dart';

class MainLoginView extends StatefulWidget {
  const MainLoginView({super.key});

  @override
  State<MainLoginView> createState() => _LoginState();
}

class _LoginState extends State<MainLoginView> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            bottomNavigationBar:BottomNavigationMenu(),
            body: TabBarView(
              children: [
                Login(),
                const SetEmailAdresse(),
                const RequestUserData()
              ],
            )
        )
    );
  }
}