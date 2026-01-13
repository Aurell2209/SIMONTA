enum JenisDokumen { proposal, lpj }

enum StatusDokumen { selesai, proses, kendala }

class Dokumen {
  String id;
  String judul;
  DateTime tanggal;
  JenisDokumen jenis;
  StatusDokumen status;
  String keterangan;

  Dokumen({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.jenis,
    required this.status,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal.toIso8601String(),
      'jenis': jenis.toString().split('.').last,
      'status': status.toString().split('.').last,
      'keterangan': keterangan,
    };
  }

  factory Dokumen.fromJson(Map<String, dynamic> json) {
    return Dokumen(
      id: json['id'],
      judul: json['judul'],
      tanggal: DateTime.parse(json['tanggal']),
      jenis: JenisDokumen.values.firstWhere(
        (e) => e.toString().split('.').last == json['jenis'],
      ),
      status: StatusDokumen.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      keterangan: json['keterangan'],
    );
  }

  String get jenisString {
    switch (jenis) {
      case JenisDokumen.proposal:
        return 'Proposal';
      case JenisDokumen.lpj:
        return 'LPJ';
    }
  }

  String get statusString {
    switch (status) {
      case StatusDokumen.selesai:
        return 'Selesai';
      case StatusDokumen.proses:
        return 'Proses';
      case StatusDokumen.kendala:
        return 'Kendala';
    }
  }
}
