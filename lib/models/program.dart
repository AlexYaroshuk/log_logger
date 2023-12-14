class Program {
  final int id;
  final String name;
  final String createTime;

  Program({
    required this.id,
    required this.name,
    required this.createTime,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
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
