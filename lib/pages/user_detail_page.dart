import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user.dart';

class UserDetailPage extends StatelessWidget {
  final int userId;

  UserDetailPage(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .fetchUserById(userId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user'));
          } else {
            User user = snapshot.data as User;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  SizedBox(height: 20),
                  Text('Name: ${user.firstName} ${user.lastName}',
                      style: TextStyle(fontSize: 20)),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 20)),
                  // Display more user data if available
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
