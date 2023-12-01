enum SessionStatus { started, finished, failed }

class Session {
  final int id;
  final int scriptId;
  final String name;
  final SessionStatus status;
  final String createTime;
  final String updateTime;

  Session({
    required this.id,
    required this.scriptId,
    required this.name,
    required this.status,
    required this.createTime,
    required this.updateTime,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? 0,
      scriptId: json['script_id'] ?? 0,
      name: json['name'] ?? '',
      status: _parseSessionStatus(json['status']),
      createTime: json['create_time'] ?? '',
      updateTime: json['create_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scriptId': scriptId,
      'name': name,
      'status': status.toString().split('.').last.toUpperCase(),
      'create_time': createTime,
      'update_time': updateTime,
    };
  }
}

SessionStatus _parseSessionStatus(String? statusString) {
  switch (statusString) {
    case 'started':
      return SessionStatus.started;
    case 'finished':
      return SessionStatus.finished;
    case 'failed':
      return SessionStatus.failed;

    default:
      throw ArgumentError('Invalid session status: $statusString');
  }
}
