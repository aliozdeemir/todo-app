import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/models/task_model.dart';

class TaskSearchDelegate extends SearchDelegate {
  final List<TaskModel> tasks;

  TaskSearchDelegate({required this.tasks});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredTasks = tasks
        .where(
          (task) => task.title.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
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
              title: Text(filteredTasks[index].title),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Text(
                    filteredTasks[index].dueDate
                        .toString()
                        .trim()
                        .substring(0, 10),
                  ),
                  Text(
                    filteredTasks[index].dueDate
                        .toString()
                        .trim()
                        .substring(11, 16),
                  ),
                ],
              ),
              leading: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          filteredTasks[index].isCompleted
                          ? Colors.green
                          : Colors.grey,
                      width: 2.w,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: filteredTasks[index].isCompleted
                        ? Colors.green
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestedTasks = tasks
        .where(
          (task) => task.title.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return ListView.builder(
      itemCount: suggestedTasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestedTasks[index].title),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                suggestedTasks[index].dueDate
                    .toString()
                    .trim()
                    .substring(0, 10),
              ),
              Text(
                suggestedTasks[index].dueDate
                    .toString()
                    .trim()
                    .substring(11, 16),
              ),
            ],
          ),
          leading: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: suggestedTasks[index].isCompleted
                      ? Colors.green
                      : Colors.grey,
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.check,
                color: suggestedTasks[index].isCompleted
                    ? Colors.green
                    : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
