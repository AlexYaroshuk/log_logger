import 'package:flutter/material.dart';
import '../models/log.dart';
import '../services/fetch_logs.dart';
import 'package:faker/faker.dart';

class DataSearch extends SearchDelegate<String> {
  final List<Log> logs;

  DataSearch(this.logs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = logs.where(
        (log) => log.content.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: suggestions
          .map<Widget>((log) => ListTile(
                title: RichText(
                  text: TextSpan(
                    text: log.content.substring(0,
                        log.content.toLowerCase().indexOf(query.toLowerCase())),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2, // Use the same TextStyle as your original widget's list
                    children: <TextSpan>[
                      TextSpan(
                          text: query,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: log.content.substring(log.content
                                  .toLowerCase()
                                  .indexOf(query.toLowerCase()) +
                              query.length)),
                    ],
                  ),
                ),
                onTap: () {
                  query = log.content;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = logs.where(
        (log) => log.content.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map<Widget>((log) => ListTile(
                title: RichText(
                  text: TextSpan(
                    text: log.content.substring(0,
                        log.content.toLowerCase().indexOf(query.toLowerCase())),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2, // Use the same TextStyle as your original widget's list
                    children: <TextSpan>[
                      TextSpan(
                          text: query,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          )),
                      TextSpan(
                          text: log.content.substring(log.content
                                  .toLowerCase()
                                  .indexOf(query.toLowerCase()) +
                              query.length)),
                    ],
                  ),
                ),
                onTap: () {
                  close(context, log.content);
                },
              ))
          .toList(),
    );
  }
}

class ListPage extends StatefulWidget {
  final String category;

  ListPage({required this.category});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Log>> futureLogs;
  List<Log> logs = [];
  final faker = Faker();

// ?? placeholders
  @override
  void initState() {
    super.initState();
    futureLogs = Future.value(_getPlaceholderLogs());
  }

  List<Log> _getPlaceholderLogs() {
    logs = List<Log>.generate(20, (index) {
      return Log(
        category: 'Category 1',
        content: faker.lorem.sentence(),
        isError: index % 4 == 0, // Every other log will be an error
      );
    });
    return logs;
  }

// ?? actual
/*   @override
void initState() {
  super.initState();
  futureLogs = fetchLogs(widget.category).then((fetchedLogs) {
    logs = fetchedLogs;
    return fetchedLogs;
  });
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
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: DataSearch(logs));
                  },
                ),
              ],
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
