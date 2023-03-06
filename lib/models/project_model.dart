import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/base/base_state.dart';

class ProjectModel extends Equatable {
  String id;
  final String name;
  final int indexColor;
  final DateTime timeCreate;
  final List<String> listTask;

  ProjectModel({
    this.id = '',
    required this.name,
    required this.indexColor,
    required this.listTask,
    required this.timeCreate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    List<String> list = [];
    if (json["listTask"] != null)
      for (int i = 0; i < (json["listTask"] as List).length; i++) {
        list.add(json["listTask"][i]);
      }
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      indexColor: json['index_color'],
      timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        json['time_create'],
      ),
      listTask: list,
    );
  }

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    List<String> list = [];
    for (int i = 0; i < doc["list_task"].length; i++) {
      list.add(doc["list_task"][i]);
    }
    return ProjectModel(
      id: doc.id,
      name: doc['name'],
      indexColor: doc['index_color'],
      timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        doc['time_create'],
      ),
      listTask: list,
    );
  }

  factory ProjectModel.fromMap(Map<String, dynamic> doc) {
    List<String> list = [];
    for (int i = 0; i < doc["list_task"].length; i++) {
      list.add(doc["list_task"][i]);
    }
    return ProjectModel(
      id: doc['id'],
      name: doc['name'],
      indexColor: doc['index_color'],
      timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
        doc['time_create'],
      ),
      listTask: list,
    );
  }

  String toJson() => jsonEncode({
        'id': this.id,
        'name': this.name,
        'index_color': this.indexColor,
        'time_create':
            DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
        'list_task': this.listTask,
      });

  Map<String, dynamic> toFirestore() => {
        'name': this.name,
        'index_color': this.indexColor,
        'time_create':
            DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
        "list_task": this.listTask,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
