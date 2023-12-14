import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/log.dart';
import '../services/fetch_logs.dart';

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
  bool _isSearching = false; // Add this
  String _searchQuery = "";
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  final int _limit = 100;
  bool _isLoading = false;
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() async {
    setState(() {
      _isLoading = true;
    });
    List<Log> newLogs =
        await fetchLogs(widget.sessionId, offset: _offset, limit: _limit);
    setState(() {
      _offset += _limit;
      logs.addAll(newLogs);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List filteredLogs = logs
        .where((log) =>
            log.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    focusNode: _searchFocusNode,
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
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchQuery = "";
                    } else {
                      _isSearching = true;
                      _searchFocusNode
                          .requestFocus(); // Request focus when search is activated
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                    }
                  });
                },
              ),
            ],
            /*    bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'All Logs'),
                Tab(text: 'Error Logs'),
              ],
            ), */
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            double maxWidth = constraints.maxWidth - 16;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        width: maxWidth * 0.1,
                        child: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: maxWidth * 0.2,
                        child: Text('Created',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: maxWidth * 0.2,
                        child: Center(
                            child: Text('Level',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      Container(
                        width: maxWidth * 0.5,
                        child: Text('Content',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: filteredLogs.isEmpty && _searchQuery.isNotEmpty
                        ? Center(
                            child: Text("No logs found for '${_searchQuery}'"))
                        : ListView.separated(
                            controller: _scrollController,
                            itemCount: _isLoading
                                ? filteredLogs.length + 2
                                : filteredLogs.length + 1,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey),
                            itemBuilder: (context, index) {
                              if (index == filteredLogs.length) {
                                return _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox.shrink();
                              } else if (index == filteredLogs.length + 1) {
                                return _isLoading
                                    ? Container(height: 50.0)
                                    : SizedBox.shrink();
                              } else {
                                Log log = filteredLogs[index];
                                int start = log.content
                                    .toLowerCase()
                                    .indexOf(_searchQuery.toLowerCase());
                                int end = start + _searchQuery.length;

                                return Row(
                                  children: <Widget>[
                                    Container(
                                      width: maxWidth * 0.1,
                                      child: Text(log.id.toString()),
                                    ),
                                    Container(
                                      width: maxWidth * 0.2,
                                      child: Text(log.formattedTime),
                                    ),
                                    Container(
                                      width: maxWidth * 0.2,
                                      child: Center(
                                          child: Text(log.level
                                              .toString()
                                              .split('.')
                                              .last)),
                                    ),
                                    Container(
                                      width: maxWidth * 0.5,
                                      child: RichText(
                                        text: TextSpan(
                                          text: log.content.substring(0, start),
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: log.content
                                                  .substring(start, end),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: log.content.substring(end),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
