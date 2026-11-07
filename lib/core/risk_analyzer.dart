/// Pemeriksaan heuristik untuk keperluan edukasi/demonstrasi.
/// BUKAN layanan antivirus, pemantau notifikasi, atau detektor phishing akurat.
enum RiskLevel { low, medium, high }

class RiskAssessment {
  const RiskAssessment({
    required this.score,
    required this.level,
    required this.reasons,
    required this.recommendations,
  });

  final int score;
  final RiskLevel level;
  final List<String> reasons;
  final List<String> recommendations;

  String get label {
    switch (level) {
      case RiskLevel.low:
        return 'Risiko rendah';
      case RiskLevel.medium:
        return 'Perlu waspada';
      case RiskLevel.high:
        return 'Risiko tinggi';
    }
  }
}

class RiskAnalyzer {
  const RiskAnalyzer();

  RiskAssessment analyze(String input) {
    final message = input.trim().toLowerCase();
    if (message.isEmpty) {
      throw ArgumentError('Pesan tidak boleh kosong.');
    }

    var score = 5;
    final reasons = <String>[];

    void signal(bool matched, int weight, String explanation) {
      if (matched) {
        score += weight;
        reasons.add(explanation);
      }
    }

    final hasUrl = RegExp(r'(https?://|www\.|\b[a-z0-9-]+\.(?:com|net|id|xyz|top|site|click|info|online)\b)', caseSensitive: false).hasMatch(message);
    signal(hasUrl, 12, 'Pesan memuat alamat atau tautan situs.');
    signal(RegExp(r'(bit\.ly|tinyurl\.com|t\.co/|s\.id/|shorturl|cutt\.ly)').hasMatch(message),
        25, 'Tautan dipersingkat sehingga tujuan aslinya sulit diketahui.');
    signal(RegExp(r'(otp|one.time.password|kode verifikasi|kode rahasia|pin\b|password|kata sandi)').hasMatch(message),
        28, 'Pesan menyebut kode atau kredensial yang bersifat rahasia.');
    signal(RegExp(r'(segera|dalam 24 jam|batas waktu|terakhir hari ini|sekarang juga|urgent|akun.*(?:blokir|ditutup|dibekukan)|ancaman)').hasMatch(message),
        18, 'Ada tekanan waktu atau ancaman untuk segera bertindak.');
    signal(RegExp(r'(klik|ketuk|kunjungi|buka tautan|login|masuk ke|verifikasi akun|konfirmasi akun)').hasMatch(message) && hasUrl,
        15, 'Pesan mendorong membuka tautan atau memasukkan data.');
    signal(RegExp(r'(transfer|bayar|biaya admin|rekening|saldo|dana|hadiah|menang undian|klaim hadiah)').hasMatch(message),
        15, 'Pesan melibatkan uang, saldo, atau iming-iming hadiah.');
    signal(RegExp(r'(jangan beri tahu|jangan bagikan ke siapapun|rahasia|jangan hubungi|tanpa konfirmasi)').hasMatch(message),
        13, 'Pesan meminta tindakan dilakukan secara tersembunyi.');

    if (reasons.isEmpty) {
      reasons.add('Tidak ditemukan pola mencurigakan dari aturan sederhana yang tersedia.');
    }
    final boundedScore = score.clamp(0, 100).toInt();
    final level = boundedScore >= 60
        ? RiskLevel.high
        : boundedScore >= 25
            ? RiskLevel.medium
            : RiskLevel.low;

    final recommendations = <String>[
      'Jangan memberikan OTP, PIN, atau kata sandi melalui pesan.',
      'Periksa identitas pengirim lewat kanal resmi yang kamu buka sendiri.',
      if (level != RiskLevel.low)
        'Hindari membuka tautan atau mentransfer uang sebelum melakukan verifikasi.',
      'Hasil ini hanya indikator berbasis aturan dan bisa keliru.',
    ];
    return RiskAssessment(
      score: boundedScore,
      level: level,
      reasons: List.unmodifiable(reasons),
      recommendations: List.unmodifiable(recommendations),
    );
  }
}
