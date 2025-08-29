import 'package:hive/hive.dart';
import 'package:todo_app/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required TaskModel task});
  Future<TaskModel?> getTask({required String id});
  Future<List<TaskModel>> getAllTasks();
  Future<bool> deleteTask({required TaskModel task});
  Future<TaskModel> updateTask({required TaskModel task});
}

class HiveLocalStorage implements LocalStorage {
  late Box<TaskModel> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<TaskModel>('tasks');
  }

  @override
  Future<void> addTask({required TaskModel task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required TaskModel task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    List<TaskModel> tasks = [];
    tasks = _taskBox.values.toList();
    if (tasks.isNotEmpty) {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
    return tasks;
  }

  @override
  Future<TaskModel?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<TaskModel> updateTask({
    required TaskModel task,
  }) async {
    await task.save();
    return task;
  }
}
