import 'package:example/data/consts/collections/collections.dart';
import 'package:example/data/consts/model_fields/likes_fields.dart';

class DbLikes{

  Future setLikesData({String? currentUserId, String? selectedUserId,bool? likeValue}) async {
    await Collections.likes.doc(currentUserId).collection(Collections.likesList).doc(selectedUserId).set({
        LikesFields.uid:selectedUserId,
        LikesFields.likeValue:likeValue
    });
  }
}