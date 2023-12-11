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
                        .bodyMedium, // Use the same TextStyle as your original widget's list
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
                        .bodyMedium, // Use the same TextStyle as your original widget's list
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

class LogsPage extends StatefulWidget {
  final int sessionId;

  LogsPage({required this.sessionId});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late Future<List<Log>> futureLogs;
  List<Log> logs = [];
  final faker = Faker();
  bool _isSearching = false; // Add this
  String _searchQuery = "";

// ?? placeholders
  /* @override
  void initState() {
    super.initState();
    futureLogs = Future.value(_getPlaceholderLogs());
  }

  List<Log> _getPlaceholderLogs() {
    logs = List<Log>.generate(20, (index) {
      return Log(
        /*   category: 'Category 1', */
        id: faker.lorem(),
        contednt: faker.lorem.sentence(),
        isError: index % 4 == 0, // Every other log will be an error
      );
    });
    return logs;
  } */

// ?? actual
  @override
  void initState() {
    super.initState();
    futureLogs = fetchLogs(widget.sessionId).then((fetchedLogs) {
      logs = fetchedLogs;
      return fetchedLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: _isSearching // Add this
                  ? TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search logs...",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    )
                  : Text('logs for sessionId = ${widget.sessionId} ',
                      style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey[700],
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: Icon(
                      _isSearching ? Icons.close : Icons.search), // Change this
                  onPressed: () {
                    setState(() {
                      if (_isSearching) {
                        _isSearching = false;
                        _searchQuery = "";
                      } else {
                        _isSearching = true;
                      }
                    });
                  },
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                      child: FutureBuilder<List<Log>>(
                    future: futureLogs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("All Logs");
                      } else if (snapshot.hasError) {
                        return Text("All Logs");
                      } else {
                        return Text("All Logs ${snapshot.data!.length}");
                      }
                    },
                  )),
                  Tab(text: 'Error Logs'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FutureBuilder<List<Log>>(
                    future: futureLogs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        ));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        var filteredLogs = snapshot.data!
                            .where((log) => log.content
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                        if (filteredLogs.isEmpty) {
                          return Center(
                              child: Text(_isSearching
                                  ? "No results found for '$_searchQuery'"
                                  : 'No logs'));
                        }
                        return LayoutBuilder(builder: (context, constraints) {
                          var maxWidth = constraints.maxWidth - 16;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: maxWidth *
                                            0.25, // 1/4 of the total width
                                        child: Text('Create Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        width: maxWidth *
                                            0.25, // 1/4 of the total width
                                        child: Center(
                                            child: Text('Level',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                      Container(
                                        width: maxWidth *
                                            0.5, // 1/2 of the total width
                                        child: Text('Content',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: filteredLogs.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(color: Colors.grey),
                                    itemBuilder: (context, index) {
                                      var log = filteredLogs[index];
                                      var start = log.content
                                          .toLowerCase()
                                          .indexOf(_searchQuery.toLowerCase());
                                      var end = start + _searchQuery.length;
                                      return Row(
                                        children: <Widget>[
                                          Container(
                                            width: maxWidth *
                                                0.25, // 1/4 of the total width
                                            child: Text(log.createTime),
                                          ),
                                          Container(
                                            width: maxWidth *
                                                0.25, // 1/4 of the total width
                                            child: Center(
                                                child: Text(log.level
                                                    .toString()
                                                    .split('.')
                                                    .last)),
                                          ),
                                          Container(
                                            width: maxWidth *
                                                0.5, // 1/2 of the total width
                                            child: RichText(
                                              text: TextSpan(
                                                text: log.content
                                                    .substring(0, start),
                                                style: DefaultTextStyle.of(
                                                        context)
                                                    .style
                                                    .copyWith(
                                                        fontSize:
                                                            12), // Reduced font size
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: log.content
                                                        .substring(start, end),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: log.content
                                                        .substring(end),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }
                    }),
                FutureBuilder<List<Log>>(
                  future: futureLogs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ));
                    } else if (snapshot.hasData) {
                      final errorLogs = snapshot.data!
                          .where((log) =>
                              log.level
                                  .toString()
                                  .split('.')
                                  .last
                                  .toLowerCase() ==
                              'error')
                          .toList();
                      if (errorLogs.isEmpty) {
                        return Center(child: Text('No error logs found.'));
                      }
                      return ListView.builder(
                        itemCount: errorLogs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(errorLogs[index].content),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/log',
                                arguments: errorLogs[index],
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container(); // Return an empty Container as a fallback
                  },
                ),
              ],
            )));
  }
}
