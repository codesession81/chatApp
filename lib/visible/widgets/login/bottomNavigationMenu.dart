import 'package:flutter/material.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu({super.key});

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(icon: Icon(Icons.login,color: Colors.lightGreen,size: 30,)),
          Tab(icon: Icon(Icons.person_add_alt_1_outlined,color: Colors.lightGreen,size: 30,)),
          Tab(icon: Icon(Icons.info_outline,color: Colors.lightGreen,size: 30,)),
        ],
      ),
    );
  }
}