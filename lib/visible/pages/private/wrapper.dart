import 'package:example/data/database/offline/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/member.dart';
import '../mainLoginView.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

 
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final listAllMembers = Provider.of<List<Member>>(context);
    Cache.loadingMemberStreamInLocalDb(listAllMembers);
    
    if(user==null){
      return const MainLoginView();
    }else{
      return Home(user);
    }
  }
}
