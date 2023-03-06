import 'dart:convert';

import 'package:hive/hive.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';

class ProjectViewModel extends BaseViewModel {
  BehaviorSubject<List<ProjectModel>?> bsProject = BehaviorSubject();

  ProjectViewModel(ref) : super(ref) {
    if (user != null)
      firestoreService.projectStream(user!.uid).listen((event) {
        bsProject.add(event);
      });
  }

  List<ProjectModel> LocalProjects(Box box) {
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

  void addProject(String name, int indexColor) {
    var temp = new ProjectModel(
      name: name,
      indexColor: indexColor,
      timeCreate: DateTime.now(),
      listTask: [],
    );
    firestoreService.LocalAddProject(temp);
  }

  void deleteProject(ProjectModel project) {
    firestoreService.localDeleteProject(project);
    for (var task in project.listTask) {
      firestoreService.deleteTask(task);
    }
  }

  @override
  void dispose() {
    bsProject.close();
    super.dispose();
  }
}
