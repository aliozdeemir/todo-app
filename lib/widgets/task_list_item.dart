import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskListItem extends StatefulWidget {
  final TaskModel task;
  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  final TextEditingController _controller =
      TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.task.title;
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(
                (0.3 * 255).toInt(),
              ),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              setState(() {
                widget.task.isCompleted =
                    !widget.task.isCompleted;
              });
              _localStorage.updateTask(task: widget.task);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.task.isCompleted
                      ? Colors.green
                      : Colors.grey,
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.check,
                color: widget.task.isCompleted
                    ? Colors.green
                    : Colors.white,
              ),
            ),
          ),
          title: widget.task.isCompleted
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 8.w,
                  ),
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                      decoration:
                          TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                )
              : TextField(
                  controller: _controller,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.length > 3) {
                      widget.task.title = value;
                      _localStorage.updateTask(
                        task: widget.task,
                      );
                    }
                  },
                ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.task.dueDate
                    .toString()
                    .trim()
                    .substring(0, 10),
              ),
              Text(
                widget.task.dueDate
                    .toString()
                    .trim()
                    .substring(11, 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
