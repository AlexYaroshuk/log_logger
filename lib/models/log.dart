enum LogLevel { info, debug, warning, error, critical }

class Log {
  final int id;
  final int sessionId;
  final LogLevel level;
  final String content;
  final String ip;
  final String createTime;

  Log({
    required this.id,
    required this.sessionId,
    required this.level,
    required this.content,
    required this.ip,
    required this.createTime,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'] ?? 0,
      sessionId: json['session_id'] ?? 0,
      level: _parseLogLevel(json['level']),
      content: json['content'] ?? '',
      ip: json['ip'] ?? '',
      createTime: json['create_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'level': level.toString().split('.').last.toUpperCase(),
      'content': content,
      'ip': ip,
      'create_time': createTime,
    };
  }
}

LogLevel _parseLogLevel(String? levelString) {
  switch (levelString?.toUpperCase()) {
    case 'INFO':
      return LogLevel.info;
    case 'DEBUG':
      return LogLevel.debug;
    case 'WARNING':
      return LogLevel.warning;
    case 'ERROR':
      return LogLevel.error;
    case 'CRITICAL':
      return LogLevel.critical;
    default:
      throw ArgumentError('Invalid log level: $levelString');
  }
}
