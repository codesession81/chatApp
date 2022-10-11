

import '../models/match.dart';
import '../models/member.dart';

class GlobalData{
  static Member? currentUser;
  static List<Member>? filteredMemberList;
  static List<Match>? currentUserMatchList;
  static List<Member>? memberListNoCurrentUser;
  static List<Member>? allMember;
  static String? emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static double deviceWith=0.0;
  static double deviceHeight=0.0;
  static num? counter;
 }