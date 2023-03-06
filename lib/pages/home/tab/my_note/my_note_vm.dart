import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';

import '/base/base_view_model.dart';
import '/models/quick_note_model.dart';

class MyNoteViewModel extends BaseViewModel {
  BehaviorSubject<List<QuickNoteModel>?> bsListQuickNote =
      BehaviorSubject<List<QuickNoteModel>>();

  MyNoteViewModel(ref) : super(ref) {
    firestoreService.LocalQuickNoteStream().listen((event) {
      print(event.toString());
      bsListQuickNote.add(event);
    });
  }

  List<QuickNoteModel> LocalQuickNotes(Box box) {
    print(box.toMap().values);
    List<QuickNoteModel> data = [];
    box.toMap().forEach((key, value) {
      data.add(QuickNoteModel.fromJson(jsonDecode(value.toString())));
    });

    return data;
  }

  void successfulQuickNote(QuickNoteModel quickNoteModel) {
    // update to local
    quickNoteModel.isSuccessful = true;
    // update to network
    firestoreService.LocalUpdateQuickNote(quickNoteModel);
  }

  void checkedNote(QuickNoteModel quickNoteModel, int idNote) {
    // check note
    quickNoteModel.listNote[idNote].check = true;
    // update note to network
    firestoreService.LocalUpdateQuickNote(quickNoteModel);
  }

  void deleteNote(QuickNoteModel quickNoteModel) async {
    // delete note in network
    await firestoreService.LocalDeleteQuickNote(quickNoteModel.id);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
