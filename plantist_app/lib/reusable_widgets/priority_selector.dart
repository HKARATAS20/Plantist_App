import 'package:flutter/cupertino.dart';

void showPrioritySelector(
    BuildContext context, Function(String) onPrioritySelected) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text('Select Priority'),
      actions: [
        CupertinoActionSheetAction(
          child: const Text('Low'),
          onPressed: () {
            onPrioritySelected('Low');
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text('Normal'),
          onPressed: () {
            onPrioritySelected('Normal');
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text('High'),
          onPressed: () {
            onPrioritySelected('High');
            Navigator.pop(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
