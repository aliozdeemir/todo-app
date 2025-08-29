import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/ui_helper.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegete.dart';

class CustomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Function showAddTaskBottomSheet;
  final List<TaskModel> tasks;
  const CustomAppBar({
    super.key,
    required this.showAddTaskBottomSheet,
    required this.tasks,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final String _selectedTheme = "light";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          widget.showAddTaskBottomSheet(context);
        },
        child: Text(
          "title",
          style: TextStyle(
            fontSize: UiHelper.getAppBarFontSize(),
          ),
        ).tr(),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            _showSearchPage(context);
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  void _showSearchPage(BuildContext context) {
    showSearch(
      context: context,
      delegate: TaskSearchDelegate(tasks: widget.tasks),
    );
  }
}
