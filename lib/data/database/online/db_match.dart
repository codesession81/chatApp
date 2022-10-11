
import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/model_fields/match_msg_fields.dart';
import 'package:example/data/consts/model_fields/matchs_fields.dart';
import 'package:example/data/consts/msg_categories/msg_categories.dart';
import 'package:example/data/models/member.dart';
import 'package:uuid/uuid.dart';

class DbMatch{

  Future setMatch({Member? selectedUser,Member? currentUser,num? currentUserMatchCount}) async {
     final uuid = Uuid();
     final String chatId =uuid.v1();
    await Collections.matchs.doc(currentUser?.uid).collection(Collections.matchLists).doc(selectedUser?.uid).set({
      MatchsFields.uid:selectedUser?.uid,
      MatchsFields.username:selectedUser?.username,
      MatchsFields.profilImageURl:selectedUser?.profilImage,
      MatchsFields.counterNewMatchMsg:0,
      MatchsFields.message:'',
      MatchsFields.createdAt:'',
      MatchsFields.chatId: chatId,
      MatchsFields.accountDeleted:false,
    });

    await Collections.matchs.doc(selectedUser?.uid).collection(Collections.matchLists).doc(currentUser?.uid).set({
      MatchsFields.uid:selectedUser?.uid,
      MatchsFields.username:selectedUser?.username,
      MatchsFields.profilImageURl:selectedUser?.profilImage,
      MatchsFields.counterNewMatchMsg:0,
      MatchsFields.message:'',
      MatchsFields.createdAt:'',
      MatchsFields.chatId: chatId,
      MatchsFields.accountDeleted:false,
    });
  }


  Future uploadMessage({String? senderID,String? empfaengerID, String? message, String? senderProfilImageURl, String? senderUsername,String? chatId,dynamic matchNewMsgCount}) async {
    String createdAt = DateTime.now().toString();
    await Collections.chats
        .doc(chatId)
        .collection(Collections.chatList)
        .doc(createdAt.toString())
        .set({
      MatchMsgFields.message: message,
      MatchMsgFields.senderId: senderID,
      MatchMsgFields.senderUsername: senderUsername,
      MatchMsgFields.senderProfilImageURl: senderProfilImageURl,
      MatchMsgFields.createdAt:createdAt,
      MatchMsgFields.isDeleted: false,
      MatchMsgFields.msgType: MsgCategories.msgTypeText,
      MatchMsgFields.msgCategory:MsgCategories.msgCategoryMatchs
    });

    await Collections.matchs.doc(empfaengerID).collection(Collections.matchLists).doc(senderID).update({
      MatchMsgFields.message: message,
      MatchMsgFields.createdAt: createdAt.toString(),
    });

    await Collections.matchs.doc(senderID).collection(Collections.matchLists).doc(empfaengerID).update({
      MatchMsgFields.message: message,
     MatchMsgFields.createdAt: createdAt.toString(),
    });
  }

  Future deleteMessage({String? createdAt,String? chatId})async{
    await Collections.chats
        .doc(chatId)
        .collection(Collections.chatList)
        .doc(createdAt.toString())
        .update({
      MatchMsgFields.message: "Nachricht wurde gelöscht",
      MatchMsgFields.createdAt:createdAt,
      MatchMsgFields.msgCategory:MsgCategories.msgCategoryMatchs
    });
  }
}