import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'user_detail_page.dart';
import 'add_user_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false).fetchUsers(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<UserProvider>(
                    builder: (ctx, userProvider, child) => ListView.builder(
                      itemCount: userProvider.users.length,
                      itemBuilder: (ctx, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProvider.users[i].avatar),
                        ),
                        title: Text(
                            '${userProvider.users[i].firstName} ${userProvider.users[i].lastName}'),
                        subtitle: Text(userProvider.users[i].email),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  UserDetailPage(userProvider.users[i].id),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddUserPage(),
            ),
          );
        },
      ),
    );
  }
}
