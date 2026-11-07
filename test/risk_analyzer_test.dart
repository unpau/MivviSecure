import 'package:flutter_test/flutter_test.dart';
import 'package:mivvi_secure/core/risk_analyzer.dart';

void main() {
  const analyzer = RiskAnalyzer();

  test('pesan normal tidak terindikasi tinggi', () {
    final result = analyzer.analyze('Halo, rapat dimulai jam sepuluh pagi.');
    expect(result.level, RiskLevel.low);
    expect(result.score, lessThan(25));
  });

  test('pesan dengan ancaman, tautan dan OTP berisiko tinggi', () {
    final result = analyzer.analyze('Segera login ke https://akun-verifikasi.xyz dalam 24 jam dan masukkan OTP karena akun diblokir!');
    expect(result.level, RiskLevel.high);
    expect(result.score, greaterThanOrEqualTo(60));
    expect(result.reasons, isNotEmpty);
  });

  test('pesan kosong ditolak', () {
    expect(() => analyzer.analyze('  '), throwsArgumentError);
  });

  test('skor tidak melewati 100', () {
    final result = analyzer.analyze('Segera sekarang juga OTP password PIN klaim hadiah transfer biaya admin klik bit.ly/bonus https://x.xyz jangan beri tahu siapapun rekening');
    expect(result.score, inInclusiveRange(0, 100));
  });
}
