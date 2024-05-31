import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Name', info: 'John Doe'),
            ProfileRow(label: 'Email', info: 'johndoe@example.com'),
            ProfileRow(
                label: 'Photo',
                info:
                    'Photo here'), // You can replace 'Photo here' with an Image widget if you have one
            ProfileRow(label: 'About', info: 'Some information about the user'),
            ProfileRow(
                label: 'Last Seen',
                info:
                    'Last seen: 2022-05-31'), // Replace with actual last seen data
            ProfileRow(
                label: 'Created At',
                info:
                    'Created at: 2022-01-01'), // Replace with actual creation date
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String label;
  final String info;

  const ProfileRow({
    Key? key,
    required this.label,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(info),
          ),
        ],
      ),
    );
  }
}
