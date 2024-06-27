import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plantist_app/utils/todo_model.dart';

class AttachmentViewPage extends StatelessWidget {
  final Todo todo;

  const AttachmentViewPage({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.notes != "")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.notes!,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (todo.fileUrl != null) ...[
              ElevatedButton(
                onPressed: () {
                  _launchURL(todo.fileUrl!);
                },
                child: const Text('View Attachment on the Web'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
