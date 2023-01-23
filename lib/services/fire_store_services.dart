import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list/models/meta_user_model.dart';

import '/constants/app_colors.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore;
  FirestoreService(this._firebaseFirestore);

  Stream<MetaUserModel> userStreamById(String id) {
    return _firebaseFirestore
        .collection('user')
        .doc(id)
        .snapshots()
        .map((doc) => MetaUserModel.fromFirestore(doc));
  }

  Future<MetaUserModel> getUserById(String id) {
    return _firebaseFirestore
        .collection('user')
        .doc(id)
        .get()
        .then((doc) => MetaUserModel.fromFirestore(doc));
  }

  Stream<List<MetaUserModel>> userStream(String email) {
    return _firebaseFirestore
        .collection('user')
        .where('email', isNotEqualTo: email)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) {
            return MetaUserModel.fromFirestore(doc);
          }).toList(),
        );
  }

  DocumentReference getDoc(String collectionPath, String id) {
    return _firebaseFirestore.collection(collectionPath).doc(id);
  }

  Future<MetaUserModel> getMetaUserByIDoc(DocumentReference doc) {
    return doc.get().then((value) => MetaUserModel.fromFirestore(value));
  }

  Future<bool> deleteQuickNote(String uid, String id) async {
    await _firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('quick_note')
        .doc(id)
        .delete()
        .then((value) {
      servicesResultPrint("Quick note Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete quick note: $error");
      return false;
    });
    return false;
  }

  Future<void> completedTaskById(String id) async {
    await _firebaseFirestore
        .collection('task')
        .doc(id)
        .update({"completed": true}).then((value) {
      servicesResultPrint('Completed Task');
    }).catchError((error) {
      servicesResultPrint('Completed Task failed: $error');
    });
  }

  Future<void> updateDescriptionUrlTaskById(String id, String url) async {
    await _firebaseFirestore
        .collection('task')
        .doc(id)
        .update({"des_url": url}).then((value) {
      servicesResultPrint('Update url successful');
    }).catchError((error) {
      servicesResultPrint('Update url failed: $error');
    });
  }

  Future<void> updateDescriptionUrlCommentById(
      String taskId, String commentId, String url) async {
    await _firebaseFirestore
        .collection('task')
        .doc(taskId)
        .collection('comment')
        .doc(commentId)
        .update({"url": url}).then((value) {
      servicesResultPrint('Update url successful');
    }).catchError((error) {
      servicesResultPrint('Update url failed: $error');
    });
  }

  Future<void> createUserData(
      String uid, String displayName, String email) async {
    await _firebaseFirestore.collection('user').doc(uid).set({
      'display_name': displayName,
      'email': email,
    }).then((value) {
      servicesResultPrint('Create user data successful', isToast: false);
    });
  }

  Future<void> updateUserAvatar(String uid, String url) async {
    await _firebaseFirestore.collection('user').doc(uid).update({
      'url': url,
    }).then((value) {
      servicesResultPrint('Update avatar successful', isToast: false);
    });
  }

  Future<bool> deleteTask(String id) async {
    await _firebaseFirestore.collection('task').doc(id).delete().then((value) {
      servicesResultPrint("Task Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete task: $error");
      return false;
    });
    return false;
  }

  void servicesResultPrint(String result, {bool isToast = true}) async {
    print("FirebaseStore services result: $result");

    if (isToast)
      await Fluttertoast.showToast(
        msg: result,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColors.kWhiteBackground,
        textColor: AppColors.kText,
      );
  }

  Future<bool> deleteTaskNote(String uid, String id) async {
    await _firebaseFirestore
        .collection('task')
        .doc(uid)
        .collection('task_note')
        .doc(id)
        .delete()
        .then((value) {
      servicesResultPrint("Quick note Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete quick note: $error");
      return false;
    });
    return false;
  }
}
