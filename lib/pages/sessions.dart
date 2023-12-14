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
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sessions available'));
          } else {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount:
                      snapshot.data!.length + 1, // Add one more for the header
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // This is the header
                      return Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // This is your first column
                          1: FlexColumnWidth(5), // This is your second column
                          2: FlexColumnWidth(3), // This is your third column
                          3: FlexColumnWidth(5), // This is your third column
                          4: FlexColumnWidth(5), // This is your third column
                        },
                        children: [
                          TableRow(
                            children: [
                              Text('ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Created',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('IP',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              // Add more headers as needed
                            ],
                          ),
                          /*    TableRow(
                            children: [
                              Divider(),
                              Divider(),
                              Divider(),
                              Divider(),
                              Divider(),
                              // Add more dividers as needed
                            ],
                          ), */
                        ],
                      );
                    } else {
                      // This is the data
                      Session session = snapshot
                          .data![index - 1]; // Subtract one for the header
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/logs',
                            arguments: session.id,
                          );
                        },
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1), // This is your first column
                            1: FlexColumnWidth(5), // This is your second column
                            2: FlexColumnWidth(3), // This is your third column
                            3: FlexColumnWidth(5), // This is your third column
                            4: FlexColumnWidth(5), // This is your third column
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(session.id.toString()),
                                Text(session
                                    .formattedCreatedTime), // Replace with actual data
                                Text(session.status.toString().split('.').last),
                                Text(session.ip), // Replace with actual data
                                Text(session.name), // Replace with actual data
                                // Add more data fields as needed
                              ],
                            ),
                            TableRow(
                              children: [
                                Divider(),
                                Divider(),
                                Divider(),
                                Divider(),
                                Divider(),
                                // Add more dividers as needed
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ));
          }
        },
      ),
    );
  }
}
