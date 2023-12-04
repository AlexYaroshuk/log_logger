import 'package:flutter/material.dart';
import '../services/fetch_scripts.dart'; // Import the fetchScripts function
import '../models/script.dart'; // Import the Script model

class ScriptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add a Scaffold widget to maintain the app bar
      appBar: AppBar(
        // Define the app bar
        title: Text(
          'Scripts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: FutureBuilder<List<Script>>(
        future:
            fetchScripts(), //call fetchScripts(withTimeout: false) to remove the manual timeout & to see the actual error for debugging
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No scripts available'));
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
    );
  }
}
