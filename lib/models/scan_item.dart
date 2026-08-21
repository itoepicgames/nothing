class ScanItem {
  const ScanItem({
    required this.id,
    required this.rawValue,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String rawValue;
  final String type;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'rawValue': rawValue,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ScanItem.fromJson(Map<String, dynamic> json) => ScanItem(
        id: json['id'] as String,
        rawValue: json['rawValue'] as String,
        type: json['type'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
