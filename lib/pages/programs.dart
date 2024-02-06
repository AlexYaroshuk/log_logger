import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:log_viewer/services/sendToken.dart';
import '../services/fetch_programs.dart';
import '../models/program.dart';

class ProgramsPage extends StatefulWidget {
  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  Future<List<Program>>? programsFuture;

  @override
  void initState() {
    super.initState();
    programsFuture = fetchPrograms();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Programs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                programsFuture = fetchPrograms();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Program>>(

        future:
            fetchPrograms(), //call fetchPrograms(withTimeout: false) to remove the manual timeout & to see the actual error for debugging
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No programs available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot.data![index].name),
                      Text(snapshot.data![index].id.toString().split('.').last),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/sessions',
                      arguments:
                          snapshot.data![index].id, // Convert id to string
                    );
                  },
                );
              },
            );
          }
        },
      ),
     floatingActionButton: FloatingActionButton(
  onPressed: () async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String label = '';
          return AlertDialog(
            title: Text('Enter a label for this device'),
            content: TextField(
              onChanged: (value) {
                label = value;
              },
              decoration: InputDecoration(hintText: "Label"),
            ),
            actions: [
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  sendToken(token, label);
                },
              ),
            ],
          );
        },
      );
    }
  },
  child: Text("Send token"),
),
    );
  }
}
