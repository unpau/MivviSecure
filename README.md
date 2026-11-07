# Mivvi Secure — Flutter Rebuild v2.0

Mivvi Secure adalah **prototype edukasi keamanan pesan** berbasis Flutter. Aplikasi ini menyediakan pemeriksaan manual teks pesan menggunakan aturan lokal sederhana, skor risiko indikatif, alasan hasil, tips keamanan, dan riwayat selama aplikasi berjalan.

> **Penting:** Ini **mode demo**, bukan antivirus, pemindai notifikasi otomatis, pelindung pesan real-time, atau alat deteksi phishing yang tervalidasi. Data contoh diberi label CONTOH. Aplikasi tidak meminta izin membaca notifikasi dan tidak mengirim teks ke backend. Riwayat berada di memori, jadi hilang saat aplikasi ditutup/restart.

## Perubahan dari repository awal

- Memperbaiki pengaturan lingkungan Dart agar bisa dipasang di lebih banyak versi Flutter (`>=3.3.0 <4.0.0`).
- Memperbaiki konfigurasi Android Gradle, Kotlin dan label aplikasi.
- Menghapus ketergantungan UI lama yang tersebar, menggantinya dengan tema UI konsisten dan layout responsif mobile / tablet / web.
- Menambahkan **pemindai pesan manual yang benar-benar memiliki aturan lokal** (bukan sekadar tampilan statis).
- Menambahkan skor dan alasan hasil, riwayat pencarian/filter, contoh pesan, edukasi, serta pengaturan hapus riwayat.
- Mengganti tes contoh `MyApp` yang rusak dengan widget test untuk aplikasi yang sesungguhnya, plus unit test analyzer.
- Menghindari dependensi plugin pihak ketiga untuk memudahkan `flutter pub get`.

## Prasyarat

- Flutter SDK dengan Dart **3.3 atau lebih baru**, terdaftar di PATH.
- VS Code dengan ekstensi **Flutter** dan **Dart**.
- Untuk web: Google Chrome.
- Untuk Android: Android Studio + Android SDK + perangkat / emulator, Java 17.

## Menjalankan di Windows (VS Code)

1. Ekstrak ZIP, buka **folder yang berisi `pubspec.yaml`** (jangan buka ZIP-nya langsung).
2. Buka Terminal > New Terminal.
3. Jalankan satu per satu:

```powershell
flutter doctor
flutter pub get
flutter devices
flutter run -d chrome
```

Bila perangkat Chrome belum terdeteksi, pasang Chrome dan jalankan `flutter devices` lagi. Untuk emulator atau HP Android gunakan `flutter run` dan pilih perangkat yang tersedia. Kamu juga dapat tekan **F5** dan pilih **Mivvi Secure (Chrome)**.

## Jika Android gagal kompilasi

Android butuh SDK, Gradle, Kotlin dan Java yang cocok. Jalankan:

```powershell
flutter doctor -v
flutter clean
flutter pub get
flutter run
```

Pastikan `java -version` mengarah ke Java 17, dan `flutter doctor` tidak melaporkan masalah toolchain Android. Jika SDK Flutter yang terpasang punya template Android yang jauh lebih baru, regenerasi folder platform (cadangkan perubahan asli terlebih dahulu):

```powershell
flutter create --platforms=android,web .
flutter pub get
flutter run -d chrome
```

## Pengujian

```powershell
flutter analyze
flutter test
```

## Struktur

```
lib/
  main.dart                 # Entry point & lifecycle
  core/
    risk_analyzer.dart      # Logika rules untuk pemeriksaan teks
    demo_store.dart         # Data sesi + riwayat demo
  ui/
    app_theme.dart          # Palet dan tema
    screens.dart            # Welcome, dashboard, scanner, history, edukasi, detail, settings

test/
  risk_analyzer_test.dart
  widget_test.dart
```

## Batasan

- Hasil tidak membuktikan suatu pesan aman atau berbahaya.
- Tidak mendeteksi URL berbahaya menggunakan reputasi domain atau API keamanan.
- Tidak membaca notifikasi perangkat, tidak mengakses SMS/WhatsApp, dan tidak melakukan pemblokiran otomatis.
- Tidak ada login, database, sinkronisasi cloud, atau enkripsi data permanen. Tidak ada klaim keamanan kriptografi yang tidak diimplementasikan.
- Untuk produksi, lakukan analisis ancaman, perlindungan privasi, pengujian keamanan, dan tinjauan izin platform.
