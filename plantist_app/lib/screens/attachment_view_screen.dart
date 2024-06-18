import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentViewPage extends StatelessWidget {
  final String attachmentUrl;

  const AttachmentViewPage({Key? key, required this.attachmentUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Attachment View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _launchURL(attachmentUrl);
              },
              child: Text('View Attachment on the Web'),
            ),
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
