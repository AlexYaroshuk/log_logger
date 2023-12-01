import 'package:flutter/material.dart';
import '../services/fetch_sessions.dart'; // Import the fetchSessions function
import '../models/session.dart'; // Import the Session model

class SessionsPage extends StatelessWidget {
  final int scriptId;

  SessionsPage({required this.scriptId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Define the app bar
        title: Text(
          'Sessions for script ${scriptId}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Session>>(
        // Replace with your session fetching logic
        future: fetchSessions(scriptId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sessions available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot.data![index].name),
                      Text(snapshot.data![index].status
                          .toString()
                          .split('.')
                          .last),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/logs',
                      arguments: snapshot.data![index].id,
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
