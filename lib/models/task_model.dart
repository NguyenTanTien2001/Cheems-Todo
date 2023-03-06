import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TaskModel extends Equatable {
  String id;
  final String idProject;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime startDate;
  bool completed;
  String desUrl;

  TaskModel({
    this.id = '',
    required this.idProject,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.startDate,
    this.completed = false,
    this.desUrl = '',
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        idProject: json['id_project'],
        title: json['title'],
        description: json['description'],
        dueDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['due_date']),
        startDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['start_date']),
        completed: json['completed'],
        desUrl: json['des_url']);
  }

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    List<String> list = [];
    for (int i = 0; i < doc['list_member'].length; i++) {
      list.add(doc['list_member'][i]);
    }
    return TaskModel(
        id: doc.id,
        idProject: doc['id_project'],
        title: doc['title'],
        description: doc['description'],
        dueDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(doc['due_date']),
        startDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(doc['start_date']),
        completed: doc['completed'],
        desUrl: doc['des_url']);
  }

  Map<String, dynamic> toFirestore() => {
        'id': this.id,
        'id_project': this.idProject,
        'title': this.title,
        'description': this.description,
        'due_date': DateFormat("yyyy-MM-dd hh:mm:ss").format(this.dueDate),
        'start_date': DateFormat("yyyy-MM-dd hh:mm:ss").format(this.startDate),
        'completed': this.completed,
        'des_url': this.desUrl
      };

  String toJson() => jsonEncode({
        'id': this.id,
        'id_project': this.idProject,
        'title': this.title,
        'description': this.description,
        'due_date': DateFormat("yyyy-MM-dd hh:mm:ss").format(this.dueDate),
        'start_date': DateFormat("yyyy-MM-dd hh:mm:ss").format(this.startDate),
        'completed': this.completed,
        'des_url': this.desUrl
      });

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
