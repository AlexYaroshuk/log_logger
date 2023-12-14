import 'package:intl/intl.dart';

enum SessionStatus { started, finished, failed }

class Session {
  final int id;
  final int programId;
  final String name;
  final SessionStatus status;
  final String createTime;
  final String updateTime;
  final String ip;

  Session({
    required this.id,
    required this.programId,
    required this.name,
    required this.status,
    required this.createTime,
    required this.updateTime,
    required this.ip,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? 0,
      programId: json['program_id'] ?? 0,
      name: json['name'] ?? '',
      status: _parseSessionStatus(json['status']),
      createTime: json['create_time'] ?? '',
      updateTime: json['create_time'] ?? '',
      ip: json['ip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'name': name,
      'status': status.toString().split('.').last.toUpperCase(),
      'create_time': createTime,
      'update_time': updateTime,
      'ip': ip,
    };
  }

  String get formattedCreatedTime {
    DateTime parsedTime = DateTime.parse(createTime);
    return DateFormat('dd-MM-yy HH:mm:ss').format(parsedTime);
  }

  String get formattedUpdatedTime {
    DateTime parsedTime = DateTime.parse(updateTime);
    return DateFormat('dd-MM-yy HH:mm:ss').format(parsedTime);
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
