class MedicalRecord {
  final String id;
  final String fileName;
  final String downloadUrl;
  final String type;
  final DateTime uploadDate;

  MedicalRecord({
    required this.id,
    required this.fileName,
    required this.downloadUrl,
    required this.type,
    required this.uploadDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'downloadUrl': downloadUrl,
      'type': type,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      fileName: map['fileName'],
      downloadUrl: map['downloadUrl'],
      type: map['type'],
      uploadDate: DateTime.parse(map['uploadDate']),
    );
  }
}
