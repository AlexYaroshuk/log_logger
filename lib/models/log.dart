class Log {
  final bool isError;
  final String content;
  final String category;
  /*  final String ip; */

  Log(
      {required this.isError,
      required this.content,
      required this.category /* , required this.ip */});
}


/* Category > Session[] > Logs[] */