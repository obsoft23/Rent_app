import 'package:flutter/material.dart';

class AgentNotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 10, // Replace with dynamic count
        itemBuilder: (context, index) {
          return NotificationTile(
            profileImage:
                'https://via.placeholder.com/150', // Replace with actual image URL
            message: 'User123 liked your property listing.',
            timeAgo: '2h',
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String profileImage;
  final String message;
  final String timeAgo;

  const NotificationTile({
    required this.profileImage,
    required this.message,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
        radius: 24,
      ),
      title: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(timeAgo, style: TextStyle(color: Colors.grey)),
      trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
    );
  }
}
