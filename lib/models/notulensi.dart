class Notulensi {
  String id;
  String judul;
  DateTime tanggal;
  String tempat;
  String peserta;
  String hasilRapat;
  DateTime? reminderDate;

  Notulensi({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.tempat,
    required this.peserta,
    required this.hasilRapat,
    this.reminderDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal.toIso8601String(),
      'tempat': tempat,
      'peserta': peserta,
      'hasilRapat': hasilRapat,
      'reminderDate': reminderDate?.toIso8601String(),
    };
  }

  factory Notulensi.fromJson(Map<String, dynamic> json) {
    return Notulensi(
      id: json['id'],
      judul: json['judul'],
      tanggal: DateTime.parse(json['tanggal']),
      tempat: json['tempat'],
      peserta: json['peserta'],
      hasilRapat: json['hasilRapat'],
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
    );
  }
}
