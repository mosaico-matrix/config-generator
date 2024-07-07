import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dialogs/text_input_dialog.dart';

class RenamableAppBar extends StatefulWidget implements PreferredSizeWidget {

  final String initialTitle;
  final bool askOnLoad;
  final String promptText;
  final ValueChanged<String> onTitleChanged;
  RenamableAppBar({Key? key, required this.initialTitle, required this.onTitleChanged, this.askOnLoad = false, required this.promptText}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;

  @override
  _RenamableAppBarState createState() => _RenamableAppBarState();
}

class _RenamableAppBarState extends State<RenamableAppBar> {
  late String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;

    // Trigger config name change after whole widget has been built
    if (widget.askOnLoad) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _renameTitle();
      });
    }
  }

  void _renameTitle() async {
    var newName = await TextInputDialog.show(context, widget.promptText);
    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _title = newName;
        widget.onTitleChanged(newName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title, style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: _renameTitle,
        ),
      ],
    );
  }
}
