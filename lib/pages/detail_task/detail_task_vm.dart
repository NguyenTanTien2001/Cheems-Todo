import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

import '../../models/quick_note_model.dart';
import '/models/comment_model.dart';
import '/models/project_model.dart';

import '/models/meta_user_model.dart';
import '/models/task_model.dart';
import '/base/base_view_model.dart';

class DetailTaskViewModel extends BaseViewModel {
  BehaviorSubject<TaskModel?> bsTask = BehaviorSubject<TaskModel?>();
  BehaviorSubject<List<CommentModel>?> bsComment =
      BehaviorSubject<List<CommentModel>?>();
  BehaviorSubject<bool> bsShowComment = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<List<QuickNoteModel>?> bsListQuickNote =
      BehaviorSubject<List<QuickNoteModel>>();
  DetailTaskViewModel(ref) : super(ref);

  void loadNote(String taskId) {
    firestoreService.taskNoteStream(taskId).listen((event) {
      bsListQuickNote.add(event);
      print(event.length);
    });
  }

  void successfultaskNote(QuickNoteModel quickNoteModel) {
    // update to local
    quickNoteModel.isSuccessful = true;
    // update to network
    firestoreService.updateTaskNote(user!.uid, quickNoteModel);
  }

  void checkedNote(QuickNoteModel quickNoteModel, int idNote) {
    // check note
    quickNoteModel.listNote[idNote].check = true;
    // update note to network
    firestoreService.updateTaskNote(user!.uid, quickNoteModel);
  }

  void deleteNote(QuickNoteModel quickNoteModel) async {
    // delete note in network
    await firestoreService.deleteTaskNote(user!.uid, quickNoteModel.id);
  }

  void loadTask(String taskId) {
    firestoreService.taskStreamById(taskId).listen((event) {
      bsTask.add(event);
    });
  }

  void loadComment(String taskId) {
    firestoreService.commentStream(taskId).listen((event) {
      bsComment.add(event);
    });
  }

  Stream<ProjectModel> getProject(String id) {
    return firestoreService.projectStreamById(id);
  }

  ProjectModel getLocalProjectById(Box box, String id) {
    print(box.toMap().values);
    List<ProjectModel> data = [];

    // box.toMap().forEach((key, value) {
    //   box.delete(key);
    // });

    box.toMap().forEach((key, value) {
      final temp = ProjectModel.fromJson(jsonDecode(value.toString()));
      if (temp.id == id) data.add(temp);
    });

    return data.first;
  }

  TaskModel LocalTasks(Box box, String id) {
    print(box.toMap().values);
    List<TaskModel> data = [];

    // box.toMap().forEach((key, value) {
    //   box.delete(key);
    // });

    // box.deleteFromDisk();

    box.toMap().forEach((key, value) {
      final temp = TaskModel.fromJson(jsonDecode(value.toString()));
      if (temp.id == id) data.add(temp);
    });

    bsTask.add(data.first);
    return data.first;
  }

  void completedTask(String id) async {
    firestoreService.localCompletedTaskById(id);
  }

  void deleteTask(TaskModel deleTask) async {
    firestoreService.getLocalProjectById(deleTask.idProject).then((value) {
      //delete task from firebase
      firestoreService.localDeleteTask(deleTask.id);
      //delete task from project task list
      firestoreService.localDeleteTaskProject(value, deleTask.id);
    });
  }

  void setShowComment(bool value) {
    this.bsShowComment.add(value);
  }

  Future<String> newComment(String taskId, CommentModel comment) async {
    startRunning();
    // add comment to database
    String commentID = await firestoreService.addComment(comment, taskId);
    endRunning();
    return commentID;
  }

  Future<void> uploadCommentImage(
      String taskId, String commentId, String filePath) async {
    startRunning();
    await fireStorageService.uploadCommentImage(filePath, taskId, commentId);
    String url = await fireStorageService.loadCommentImage(taskId, commentId);
    firestoreService.updateDescriptionUrlCommentById(taskId, commentId, url);
    endRunning();
  }

  @override
  void dispose() {
    bsTask.close();
    bsShowComment.close();
    bsComment.close();
    bsListQuickNote.close();
    super.dispose();
  }
}
