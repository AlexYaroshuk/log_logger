import 'package:flutter/material.dart';
import '../models/log.dart';
import '../services/fetch_logs.dart';

class ListPage extends StatefulWidget {
  final String category;

  ListPage({required this.category});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Log>> futureLogs;

// ?? placeholders
  @override
  void initState() {
    super.initState();
    futureLogs = Future.value(_getPlaceholderLogs());
  }

  List<Log> _getPlaceholderLogs() {
    return List<Log>.generate(20, (index) {
      return Log(
        category: 'Category 1',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. $index',
        isError: index % 4 == 0, // Every other log will be an error
      );
    });
  }

// ?? actual
/*   @override
  void initState() {
    super.initState();
    futureLogs = fetchLogs(widget.category);
  } */

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('${widget.category} logs',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey[700],
              iconTheme: IconThemeData(color: Colors.white),
              bottom: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'All Logs'),
                  Tab(text: 'Error Logs'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FutureBuilder<List<Log>>(
                  future: futureLogs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                snapshot.data![index].content,
                                style: TextStyle(
                                  color: snapshot.data![index].isError
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/log',
                                  arguments: snapshot.data![index],
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<List<Log>>(
                  future: futureLogs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var errorLogs = snapshot.data!
                          .where((log) => log.isError)
                          .toList(); // Filter logs where isError is true
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: errorLogs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                errorLogs[index].content,
                                style: TextStyle(
                                  color: errorLogs[index].isError
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/log',
                                  arguments: snapshot.data![index],
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ],
            )));
  }
}
