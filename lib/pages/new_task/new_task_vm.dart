import 'dart:convert';

import 'package:hive/hive.dart';

import '/models/task_model.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';

class NewTaskViewModel extends BaseViewModel {
  BehaviorSubject<List<ProjectModel>?> bsListProject =
      BehaviorSubject<List<ProjectModel>>();

  NewTaskViewModel(ref) : super(ref) {
    // add project data
    if (user != null) {
      firestoreService.projectStream(user!.uid).listen((event) {
        bsListProject.add(event);
      });
    }
  }

  List<ProjectModel> getLocalProjects(Box box) {
    print(box.toMap().values);
    List<ProjectModel> data = [];

    // box.toMap().forEach((key, value) {
    //   box.delete(key);
    // });

    box.toMap().forEach((key, value) {
      data.add(ProjectModel.fromJson(jsonDecode(value.toString())));
    });

    return data;
  }

  Future<String> newTask(
      TaskModel task, ProjectModel project, List<String> listToken) async {
    // add task to database
    String taskID = await firestoreService.localAddTask(task);
    // add task to project
    firestoreService.localAddTaskProject(project, taskID);
    return taskID;
  }

  Future<void> uploadDesTask(String taskId, String filePath) async {
    startRunning();
    await fireStorageService.uploadTaskImage(filePath, taskId);
    String url = await fireStorageService.loadTaskImage(taskId);
    firestoreService.updateDescriptionUrlTaskById(taskId, url);
    endRunning();
  }

  @override
  void dispose() {
    bsListProject.close();
    super.dispose();
  }
}
