// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_field, prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/translations_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_app_bar.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<TaskModel> tumGorevler;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    tumGorevler = <TaskModel>[];
    _getAllTasksFromStorage();
  }

  Future<void> _getAllTasksFromStorage() async {
    tumGorevler = await _localStorage.getAllTasks();
    setState(() {
      tumGorevler = tumGorevler;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showAddTaskBottomSheet: _showAddTaskBottomSheet,
        tasks: tumGorevler,
      ),
      body: _buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    TextEditingController _controller =
        TextEditingController();
    DateTime? _selectedDateTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(
                context,
              ).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16.0.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'add_task',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                  SizedBox(height: 16.0.h),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'add_task'.tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0.h),
                  TextButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.all(
                        2.0,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.r),
                          side: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2100, 12, 31),
                        onConfirm: (picked) {
                          setModalState(() {
                            _selectedDateTime = picked;
                          });
                        },
                        currentTime: DateTime.now(),
                        locale:
                            TranslationsHelper.getDeviceLocale(
                              context,
                            ),
                      );
                    },
                    child: Text(
                      _selectedDateTime == null
                          ? 'date_time_picker'
                          : '${_selectedDateTime!.day}.${_selectedDateTime!.month}.${_selectedDateTime!.year} '
                                '${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                  ),
                  SizedBox(height: 16.0.h),
                  ElevatedButton(
                    onPressed: () async {
                      if (_controller.text.length > 3 &&
                          _selectedDateTime != null) {
                        var yeniEklenecekGorev =
                            TaskModel.create(
                              title: _controller.text,
                              dueDate: _selectedDateTime!,
                            );
                        setState(() {
                          tumGorevler.add(
                            yeniEklenecekGorev,
                          );
                        });
                        await _localStorage.addTask(
                          task: yeniEklenecekGorev,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('save').tr(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyWidget() {
    if (tumGorevler.isNotEmpty) {
      return ListView.builder(
        itemCount: tumGorevler.length,
        itemBuilder: (context, index) {
          final task = tumGorevler[index];
          return Dismissible(
            background: Padding(
              padding: EdgeInsets.only(left: 8.0.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 15.w),
                  const Text("delete_task").tr(),
                ],
              ),
            ),
            key: Key(task.id),
            onDismissed: (direction) async {
              await _localStorage.deleteTask(task: task);
              setState(() {
                tumGorevler.removeAt(index);
              });
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    task.title + " " + "deleted_task".tr(),
                  ).tr(),
                  action: SnackBarAction(
                    label: 'undo'.tr(),
                    onPressed: () {
                      _localStorage.addTask(task: task);
                      setState(() {
                        tumGorevler.insert(index, task);
                      });
                    },
                  ),
                ),
              );
            },
            child: TaskListItem(task: task),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          'empty_task_list'.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
  }
}
