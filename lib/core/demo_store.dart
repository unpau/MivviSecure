import 'package:flutter/foundation.dart';
import 'risk_analyzer.dart';

class ScanRecord {
  const ScanRecord({
    required this.id,
    required this.sender,
    required this.message,
    required this.date,
    required this.result,
    required this.isExample,
  });

  final int id;
  final String sender;
  final String message;
  final DateTime date;
  final RiskAssessment result;
  final bool isExample;
}

class DemoStore extends ChangeNotifier {
  DemoStore() {
    loadExamples();
  }

  final RiskAnalyzer engine = const RiskAnalyzer();
  final List<ScanRecord> _records = [];
  int _nextId = 1;
  bool _showExamples = true;

  List<ScanRecord> get records => List.unmodifiable(_records);
  bool get showExamples => _showExamples;
  int get total => _records.length;
  int get highCount => _records.where((r) => r.result.level == RiskLevel.high).length;
  int get warningCount => _records.where((r) => r.result.level == RiskLevel.medium).length;
  int get lowCount => _records.where((r) => r.result.level == RiskLevel.low).length;

  ScanRecord scan(String message, {String sender = 'Pemeriksaan manual', bool isExample = false}) {
    final cleanedMessage = message.trim();
    if (cleanedMessage.isEmpty) throw ArgumentError('Isi pesan terlebih dahulu.');
    final record = ScanRecord(
      id: _nextId++,
      sender: sender.trim().isEmpty ? 'Pemeriksaan manual' : sender.trim(),
      message: cleanedMessage,
      date: DateTime.now(),
      result: engine.analyze(cleanedMessage),
      isExample: isExample,
    );
    _records.insert(0, record);
    notifyListeners();
    return record;
  }

  void remove(int id) {
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }

  void clear() {
    _records.clear();
    _showExamples = false;
    notifyListeners();
  }

  void loadExamples() {
    if (_showExamples && _records.any((record) => record.isExample)) return;
    _showExamples = true;
    scan('PENTING! Akun bank Anda akan diblokir dalam 24 jam. Klik https://verifikasi-akun.xyz untuk login dan masukkan OTP sekarang juga.',
        sender: 'SMS • Contoh penipuan', isExample: true);
    scan('Selamat! Anda menang hadiah undian. Klaim hadiah dengan biaya admin melalui bit.ly/bonus-claim',
        sender: 'Chat • Contoh mencurigakan', isExample: true);
    scan('Halo, rapat tim hari Senin pukul 09.00 di ruang diskusi. Terima kasih.',
        sender: 'Pesan • Contoh biasa', isExample: true);
    notifyListeners();
  }
}
