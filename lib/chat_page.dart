import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ChatPage extends StatefulWidget {
  final String? outputFilePath;

  ChatPage({this.outputFilePath});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  void _shareVideo(Contact contact) {
    // Add your sharing logic here
    // You can use packages like `share` or any other method to share the video
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: _contacts == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contacts!.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts![index];
                return ListTile(
                  title: Text(contact.displayName),
                  onTap: () {
                    if (widget.outputFilePath != null) {
                      _shareVideo(contact);
                    }
                  },
                );
              },
            ),
    );
  }
}
