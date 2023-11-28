import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/list',
                arguments: categories[index],
              );
            },
          );
        },
      ),
    );
  }
}
