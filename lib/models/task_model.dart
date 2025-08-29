import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime dueDate;
  @HiveField(3)
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
  });

  factory TaskModel.create({
    required String title,
    required DateTime dueDate,
  }) {
    return TaskModel(
      id: const Uuid().v1(),
      title: title,
      dueDate: dueDate,
      isCompleted: false,
    );
  }

  @override
  String toString() {
    return "TaskModel{id: $id, title: $title, dueDate: $dueDate, isCompleted: $isCompleted}";
  }
}
