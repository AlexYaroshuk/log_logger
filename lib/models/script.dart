class Script {
  final int id;
  final String name;
  final String createTime;

  Script({
    required this.id,
    required this.name,
    required this.createTime,
  });

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createTime: json['create_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'create_time': createTime,
    };
  }
}
