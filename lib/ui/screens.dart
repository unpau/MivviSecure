import 'package:flutter/material.dart';

import '../core/demo_store.dart';
import '../core/risk_analyzer.dart';
import 'app_theme.dart';

String shortDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} · ${two(date.hour)}:${two(date.minute)}';
}

Color riskColor(RiskLevel level) {
  switch (level) {
    case RiskLevel.high:
      return Palette.red;
    case RiskLevel.medium:
      return Palette.amber;
    case RiskLevel.low:
      return Palette.green;
  }
}

IconData riskIcon(RiskLevel level) {
  switch (level) {
    case RiskLevel.high:
      return Icons.gpp_bad_outlined;
    case RiskLevel.medium:
      return Icons.warning_amber_rounded;
    case RiskLevel.low:
      return Icons.verified_user_outlined;
  }
}

class MivviHome extends StatefulWidget {
  const MivviHome({super.key, required this.store});
  final DemoStore store;

  @override
  State<MivviHome> createState() => _MivviHomeState();
}

class _MivviHomeState extends State<MivviHome> {
  bool _showIntro = true;
  int _tab = 0;

  void _viewDetail(ScanRecord record) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => DetailPage(record: record, store: widget.store),
    ));
  }

  void _openSettings() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => SettingsPage(store: widget.store),
    ));
  }

  Widget _tabContent() {
    switch (_tab) {
      case 0:
        return DashboardTab(
          store: widget.store,
          onScan: () => setState(() => _tab = 1),
          onHistory: () => setState(() => _tab = 2),
          onDetail: _viewDetail,
        );
      case 1:
        return ScanTab(store: widget.store, onScanned: _viewDetail);
      case 2:
        return HistoryTab(store: widget.store, onDetail: _viewDetail);
      default:
        return EducationTab(onScan: () => setState(() => _tab = 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return WelcomeScreen(onStart: () => setState(() => _showIntro = false));
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final wide = box.maxWidth >= 790;
            final content = Column(
              children: [
                AppHeader(onSettings: _openSettings),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 920),
                      child: ListView(
                        key: ValueKey<int>(_tab),
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
                        children: [
                          _tabContent(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!wide)
                  BottomBar(selected: _tab, onSelect: (value) => setState(() => _tab = value)),
              ],
            );
            if (!wide) return content;
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: Palette.surface,
                  selectedIndex: _tab,
                  onDestinationSelected: (value) => setState(() => _tab = value),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Palette.teal),
                  selectedLabelTextStyle: const TextStyle(color: Palette.teal, fontSize: 12),
                  unselectedLabelTextStyle: const TextStyle(color: Palette.muted, fontSize: 12),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: Text('Beranda')),
                    NavigationRailDestination(icon: Icon(Icons.manage_search_outlined), selectedIcon: Icon(Icons.manage_search), label: Text('Periksa')),
                    NavigationRailDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: Text('Riwayat')),
                    NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: Text('Edukasi')),
                  ],
                ),
                const VerticalDivider(width: 1, color: Palette.stroke),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color});
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Palette.stroke),
        ),
        child: child,
      );
}

class MiniTag extends StatelessWidget {
  const MiniTag({super.key, required this.text, this.icon, this.color = Palette.teal});
  final String text;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
            ],
            Flexible(child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))),
          ],
        ),
      );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2346), Palette.bg, Color(0xFF08232C)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 490),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 30),
                  const Center(child: BrandMark(size: 100)),
                  const SizedBox(height: 24),
                  const Center(child: MiniTag(text: 'SECURITY AWARENESS · DEMO', icon: Icons.bolt_outlined)),
                  const SizedBox(height: 22),
                  Text('Lebih cermat sebelum klik.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 12),
                  const Text(
                    'Mivvi Secure membantu mengenali tanda-tanda phishing pada pesan melalui pemeriksaan teks sederhana.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Palette.muted, height: 1.65, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  const SurfaceCard(
                    child: Column(
                      children: [
                        IntroFeature(icon: Icons.manage_search, label: 'Analisis pesan', subtitle: 'Periksa tautan, tekanan waktu, dan permintaan data rahasia.'),
                        Divider(height: 24, color: Palette.stroke),
                        IntroFeature(icon: Icons.insights_outlined, label: 'Skor indikatif', subtitle: 'Lihat alasan suatu pesan perlu diperiksa lebih lanjut.'),
                        Divider(height: 24, color: Palette.stroke),
                        IntroFeature(icon: Icons.school_outlined, label: 'Tips praktis', subtitle: 'Pelajari kebiasaan aman saat menerima pesan.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.arrow_forward_rounded), label: const Text('Mulai demo Mivvi Secure')),
                  const SizedBox(height: 14),
                  const Text(
                    'Mode demonstrasi: tidak membaca notifikasi Android atau memblokir ancaman secara otomatis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Palette.muted, height: 1.45, fontSize: 11),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * .25),
          gradient: const LinearGradient(colors: [Palette.teal, Palette.purple], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Palette.teal.withOpacity(.14), blurRadius: 25, spreadRadius: 2)],
        ),
        child: Icon(Icons.shield_rounded, color: Palette.bg, size: size * .58),
      );
}

class IntroFeature extends StatelessWidget {
  const IntroFeature({super.key, required this.icon, required this.label, required this.subtitle});
  final IconData icon;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(color: Palette.tealDark, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Palette.teal, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Palette.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: Palette.muted, height: 1.4, fontSize: 12)),
          ])),
        ],
      );
}

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.onSettings});
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        decoration: const BoxDecoration(color: Palette.surface, border: Border(bottom: BorderSide(color: Palette.stroke))),
        child: Row(children: [
          const BrandMark(size: 40),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MIVVI SECURE', style: TextStyle(color: Palette.white, fontSize: 15, letterSpacing: .5, fontWeight: FontWeight.w900)),
            Text('Pemeriksaan pesan · Versi demo', style: TextStyle(color: Palette.muted, fontSize: 11)),
          ])),
          IconButton(tooltip: 'Pengaturan & privasi', onPressed: onSettings, icon: const Icon(Icons.settings_outlined, color: Palette.muted)),
        ]),
      );
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.space_dashboard_outlined, Icons.manage_search_outlined, Icons.history, Icons.menu_book_outlined];
    const labels = ['Beranda', 'Periksa', 'Riwayat', 'Edukasi'];
    return Container(
      decoration: const BoxDecoration(color: Palette.surface, border: Border(top: BorderSide(color: Palette.stroke))),
      padding: const EdgeInsets.fromLTRB(7, 6, 7, 8),
      child: Row(children: List.generate(4, (i) => Expanded(child: InkWell(
        onTap: () => onSelect(i),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icons[i], size: 23, color: i == selected ? Palette.teal : Palette.muted),
            const SizedBox(height: 5),
            Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: i == selected ? FontWeight.w800 : FontWeight.w500, color: i == selected ? Palette.teal : Palette.muted)),
          ]),
        ),
      )))),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.subtitle, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle != null) ...[const SizedBox(height: 5), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium)],
        ])),
        if (trailing != null) trailing!,
      ]);
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key, required this.store, required this.onScan, required this.onHistory, required this.onDetail});
  final DemoStore store;
  final VoidCallback onScan;
  final VoidCallback onHistory;
  final ValueChanged<ScanRecord> onDetail;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: store, builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MiniTag(text: 'DASHBOARD / OVERVIEW', icon: Icons.circle, color: Palette.purple),
        const SizedBox(height: 13),
        Text('Kenali risiko.\nJaga keamananmu.', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text('Analisis pesan yang mencurigakan dengan langkah sederhana.', style: TextStyle(color: Palette.muted, fontSize: 14)),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [Color(0xFF173D49), Color(0xFF20254C)]),
            border: Border.all(color: Palette.teal.withOpacity(.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const MiniTag(text: 'MODE DEMO AKTIF', icon: Icons.science_outlined),
            const SizedBox(height: 15),
            const Text('Punya pesan yang bikin ragu?', style: TextStyle(color: Palette.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Salin isi pesannya ke pemeriksa. Kami akan menampilkan indikator risiko berdasarkan aturan sederhana.', style: TextStyle(color: Palette.white, height: 1.6, fontSize: 13)),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: onScan, icon: const Icon(Icons.arrow_forward), label: const Text('Periksa pesan sekarang')),
          ]),
        ),
        const SizedBox(height: 28),
        const SectionTitle(title: 'Ringkasan analisis', subtitle: 'Data contoh + pemeriksaan selama sesi ini'),
        const SizedBox(height: 13),
        LayoutBuilder(builder: (context, c) {
          final width = (c.maxWidth - 20) / 3;
          final itemWidth = width < 125 ? (c.maxWidth - 10) / 2 : width;
          return Wrap(spacing: 10, runSpacing: 10, children: [
            _Metric(label: 'Total', value: '${store.total}', icon: Icons.analytics_outlined, color: Palette.purple, width: itemWidth),
            _Metric(label: 'Risiko tinggi', value: '${store.highCount}', icon: Icons.gpp_bad_outlined, color: Palette.red, width: itemWidth),
            _Metric(label: 'Waspada', value: '${store.warningCount}', icon: Icons.warning_amber_outlined, color: Palette.amber, width: itemWidth),
          ]);
        }),
        const SizedBox(height: 28),
        SectionTitle(title: 'Pemeriksaan terbaru', trailing: TextButton(onPressed: onHistory, child: const Text('Lihat semua'))),
        const SizedBox(height: 12),
        if (store.records.isEmpty)
          const EmptyState(message: 'Belum ada pemeriksaan. Mulai analisis pesan untuk melihat hasilnya.')
        else
          ...store.records.take(3).map((record) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RecordTile(record: record, onTap: () => onDetail(record)),
          )),
        const SizedBox(height: 14),
        const InfoStrip(icon: Icons.info_outline, text: 'Hasil berbasis aturan, bukan pemeriksaan keamanan menyeluruh. Demo ini tidak mengakses notifikasi asli.'),
      ],
    ));
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon, required this.color, required this.width});
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: SurfaceCard(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 13),
            Text(value, style: const TextStyle(fontSize: 29, color: Palette.white, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(fontSize: 11, color: Palette.muted)),
          ],
        )),
      );
}

class ScanTab extends StatefulWidget {
  const ScanTab({super.key, required this.store, required this.onScanned});
  final DemoStore store;
  final ValueChanged<ScanRecord> onScanned;

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final TextEditingController _message = TextEditingController();
  final TextEditingController _sender = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    _sender.dispose();
    super.dispose();
  }

  void _submit() {
    if (_message.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan isi pesan terlebih dahulu.')));
      return;
    }
    final record = widget.store.scan(_message.text, sender: _sender.text);
    widget.onScanned(record);
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const MiniTag(text: 'MANUAL MESSAGE SCANNER', icon: Icons.manage_search),
        const SizedBox(height: 14),
        Text('Periksa pesan', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text('Tempel isi SMS, chat, atau pesan lain yang ingin kamu periksa.', style: TextStyle(color: Palette.muted, fontSize: 14)),
        const SizedBox(height: 24),
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nama pengirim (opsional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Palette.white)),
          const SizedBox(height: 8),
          TextField(controller: _sender, maxLength: 60, textInputAction: TextInputAction.next, decoration: const InputDecoration(hintText: 'Contoh: SMS, nomor tidak dikenal', counterText: '')),
          const SizedBox(height: 20),
          const Text('Isi pesan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Palette.white)),
          const SizedBox(height: 8),
          TextField(
            controller: _message,
            maxLines: 7,
            minLines: 5,
            maxLength: 2500,
            decoration: const InputDecoration(hintText: 'Tempel pesan di sini. Misalnya: Akun Anda akan diblokir...'),
          ),
          const SizedBox(height: 7),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.shield_outlined), label: const Text('Analisis pesan'))),
          const SizedBox(height: 14),
          const InfoStrip(icon: Icons.lock_outline, text: 'Teks diperiksa di aplikasi untuk demo dan tidak dikirim ke server. Riwayat hanya tersimpan selama aplikasi berjalan.'),
        ])),
        const SizedBox(height: 27),
        const SectionTitle(title: 'Coba pesan contoh', subtitle: 'Ketuk salah satu contoh untuk mengisi kolom'),
        const SizedBox(height: 12),
        _SampleButton(
          icon: Icons.warning_amber,
          title: 'Pesan mencurigakan',
          subtitle: 'Akun diblokir, tautan, dan permintaan OTP',
          onTap: () => setState(() {
            _sender.text = 'SMS • Contoh';
            _message.text = 'Akun Anda akan diblokir dalam 24 jam! Segera login ke https://akun-verifikasi.xyz dan masukkan OTP untuk konfirmasi.';
          }),
        ),
        const SizedBox(height: 10),
        _SampleButton(
          icon: Icons.chat_bubble_outline,
          title: 'Pesan biasa',
          subtitle: 'Pengingat rapat tanpa tautan atau tekanan',
          onTap: () => setState(() {
            _sender.text = 'Rekan kerja • Contoh';
            _message.text = 'Selamat siang, jangan lupa rapat evaluasi hari Kamis pukul 10.00. Terima kasih.';
          }),
        ),
        const SizedBox(height: 10),
        _SampleButton(
          icon: Icons.card_giftcard_outlined,
          title: 'Pesan hadiah',
          subtitle: 'Iming-iming hadiah dan biaya admin',
          onTap: () => setState(() {
            _sender.text = 'Chat • Contoh';
            _message.text = 'Selamat! Anda menang undian. Klik bit.ly/klaim-hadiah sekarang juga dan transfer biaya admin terlebih dahulu.';
          }),
        ),
      ]);
}

class _SampleButton extends StatelessWidget {
  const _SampleButton({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(padding: const EdgeInsets.all(17), child: Row(children: [
            Icon(icon, color: Palette.teal, size: 25),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Palette.white, fontSize: 14, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: Palette.muted, fontSize: 12)),
            ])),
            const Icon(Icons.add_circle_outline, color: Palette.purple, size: 22),
          ])),
        ),
      );
}

class RecordTile extends StatelessWidget {
  const RecordTile({super.key, required this.record, required this.onTap});
  final ScanRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = riskColor(record.result.level);
    return Material(
      color: Palette.surface,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(riskIcon(record.result.level), color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(record.sender, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Palette.white, fontSize: 13, fontWeight: FontWeight.w800))),
                if (record.isExample) const Text('CONTOH', style: TextStyle(color: Palette.purple, fontSize: 9, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 4),
              Text(record.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Palette.muted, height: 1.45, fontSize: 12)),
              const SizedBox(height: 10),
              Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(record.result.label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
                Text('Skor ${record.result.score}/100', style: const TextStyle(color: Palette.muted, fontSize: 11)),
                Text(shortDate(record.date), style: const TextStyle(color: Palette.muted, fontSize: 10)),
              ]),
            ])),
            const SizedBox(width: 3),
            const Icon(Icons.chevron_right, color: Palette.muted),
          ]),
        ),
      ),
    );
  }
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key, required this.store, required this.onDetail});
  final DemoStore store;
  final ValueChanged<ScanRecord> onDetail;

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  String _query = '';
  int _filter = 0;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.store, builder: (context, _) {
        final items = widget.store.records.where((r) {
          final matchesText = r.sender.toLowerCase().contains(_query.toLowerCase()) || r.message.toLowerCase().contains(_query.toLowerCase());
          final matchesRisk = _filter == 0 || (_filter == 1 && r.result.level == RiskLevel.high) || (_filter == 2 && r.result.level == RiskLevel.medium) || (_filter == 3 && r.result.level == RiskLevel.low);
          return matchesText && matchesRisk;
        }).toList();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const MiniTag(text: 'SESSION HISTORY', icon: Icons.history_outlined, color: Palette.purple),
          const SizedBox(height: 14),
          Text('Riwayat analisis', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 7),
          const Text('Telusuri hasil pemeriksaan selama sesi aplikasi ini.', style: TextStyle(color: Palette.muted)),
          const SizedBox(height: 20),
          TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Cari pengirim atau isi pesan')),
          const SizedBox(height: 12),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
            _FilterChip(text: 'Semua', active: _filter == 0, onTap: () => setState(() => _filter = 0)),
            _FilterChip(text: 'Risiko tinggi', active: _filter == 1, onTap: () => setState(() => _filter = 1)),
            _FilterChip(text: 'Waspada', active: _filter == 2, onTap: () => setState(() => _filter = 2)),
            _FilterChip(text: 'Risiko rendah', active: _filter == 3, onTap: () => setState(() => _filter = 3)),
          ])),
          const SizedBox(height: 23),
          SectionTitle(title: '${items.length} hasil ditemukan'),
          const SizedBox(height: 13),
          if (items.isEmpty)
            const EmptyState(message: 'Tidak ada pesan yang cocok dengan pencarian atau filter.')
          else
            ...items.map((r) => Padding(padding: const EdgeInsets.only(bottom: 10), child: RecordTile(record: r, onTap: () => widget.onDetail(r)))),
          const SizedBox(height: 12),
          const InfoStrip(icon: Icons.lock_outline, text: 'Riwayat bersifat sementara, tidak disimpan permanen, dan akan hilang saat aplikasi ditutup atau dimulai ulang.'),
        ]);
      });
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.text, required this.active, required this.onTap});
  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(text),
          selected: active,
          onSelected: (_) => onTap(),
          labelStyle: TextStyle(color: active ? Palette.bg : Palette.muted, fontSize: 12, fontWeight: FontWeight.w700),
          selectedColor: Palette.teal,
          backgroundColor: Palette.surface,
          side: const BorderSide(color: Palette.stroke),
        ),
      );
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.record, required this.store});
  final ScanRecord record;
  final DemoStore store;

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus hasil analisis?'),
        content: const Text('Data ini akan dihapus dari riwayat sesi aplikasi.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      store.remove(record.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = record.result;
    final color = riskColor(result.level);
    return Scaffold(
      appBar: AppBar(backgroundColor: Palette.bg, title: const Text('Detail analisis'), actions: [
        IconButton(onPressed: () => _delete(context), icon: const Icon(Icons.delete_outline), tooltip: 'Hapus hasil'),
      ]),
      body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MiniTag(text: record.isExample ? 'HASIL DATA CONTOH' : 'HASIL PEMERIKSAAN MANUAL', icon: Icons.science_outlined, color: Palette.purple),
            const SizedBox(height: 17),
            Row(children: [Icon(riskIcon(result.level), size: 33, color: color), const SizedBox(width: 10), Expanded(child: Text(result.label, style: TextStyle(color: color, fontSize: 23, fontWeight: FontWeight.w900)))]),
            const SizedBox(height: 13),
            RichText(text: TextSpan(children: [TextSpan(text: '${result.score}', style: const TextStyle(color: Palette.white, fontSize: 40, fontWeight: FontWeight.w900)), const TextSpan(text: ' / 100', style: TextStyle(color: Palette.muted, fontSize: 17))])),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: result.score / 100, minHeight: 10, color: color, backgroundColor: Palette.raised)),
            const SizedBox(height: 13),
            const Text('Skor indikatif berdasarkan kata dan pola tertentu, bukan probabilitas kejahatan.', style: TextStyle(fontSize: 12, color: Palette.muted, height: 1.5)),
          ])),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Pesan yang diperiksa'),
          const SizedBox(height: 12),
          SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(record.sender, style: const TextStyle(fontSize: 13, color: Palette.teal, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(shortDate(record.date), style: const TextStyle(color: Palette.muted, fontSize: 11)),
            const Divider(height: 26),
            SelectableText(record.message, style: const TextStyle(color: Palette.white, fontSize: 14, height: 1.6)),
          ])),
          const SizedBox(height: 23),
          const SectionTitle(title: 'Mengapa hasilnya demikian?'),
          const SizedBox(height: 12),
          SurfaceCard(child: Column(children: result.reasons.map((reason) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.check_circle_outline, color: color, size: 19),
            const SizedBox(width: 10),
            Expanded(child: Text(reason, style: const TextStyle(color: Palette.white, height: 1.5, fontSize: 13))),
          ]))).toList())),
          const SizedBox(height: 23),
          const SectionTitle(title: 'Langkah yang disarankan'),
          const SizedBox(height: 12),
          SurfaceCard(child: Column(children: result.recommendations.map((tip) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.arrow_right_alt, color: Palette.teal, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(color: Palette.white, height: 1.5, fontSize: 13))),
          ]))).toList())),
          const SizedBox(height: 16),
          const InfoStrip(icon: Icons.info_outline, text: 'Hasil risiko rendah tidak menjamin pesan aman. Selalu verifikasi melalui sumber resmi.'),
          const SizedBox(height: 20),
          OutlinedButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back), label: const Text('Kembali')),
        ],
      )))),
    );
  }
}

class EducationTab extends StatelessWidget {
  const EducationTab({super.key, required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const MiniTag(text: 'CYBER AWARENESS', icon: Icons.school_outlined, color: Palette.purple),
        const SizedBox(height: 14),
        Text('Pojok edukasi', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text('Kebiasaan sederhana untuk membantu melindungi akun dan data pribadimu.', style: TextStyle(fontSize: 14, color: Palette.muted)),
        const SizedBox(height: 22),
        SurfaceCard(color: const Color(0xFF1C3140), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const MiniTag(text: 'KENALI POLANYA', icon: Icons.lightbulb_outline),
          const SizedBox(height: 14),
          const Text('Phishing sering memanfaatkan rasa panik, penasaran, atau tergiur hadiah.', style: TextStyle(color: Palette.white, fontSize: 17, fontWeight: FontWeight.w800, height: 1.5)),
          const SizedBox(height: 12),
          const Text('Jangan langsung mempercayai pesan hanya karena terlihat berasal dari bank, kurir, instansi, atau teman.', style: TextStyle(color: Palette.muted, fontSize: 13, height: 1.5)),
          const SizedBox(height: 17),
          FilledButton.icon(onPressed: onScan, icon: const Icon(Icons.manage_search_outlined), label: const Text('Coba periksa pesan')),
        ])),
        const SizedBox(height: 26),
        const SectionTitle(title: 'Tips keamanan digital'),
        const SizedBox(height: 12),
        const _TipTile(icon: Icons.password_outlined, title: 'Jangan bagikan OTP & PIN', content: 'Pihak resmi tidak memerlukan OTP atau PIN akunmu lewat chat, telepon, atau tautan yang dikirim pengirim tak dikenal.'),
        const _TipTile(icon: Icons.link_off_outlined, title: 'Periksa tautan', content: 'Perhatikan domain dengan teliti. Jangan menganggap situs aman hanya karena ada ikon gembok atau HTTPS. Buka layanan dari aplikasi atau alamat resmi yang kamu ketahui.'),
        const _TipTile(icon: Icons.schedule_outlined, title: 'Waspadai tekanan waktu', content: 'Pesan yang meminta tindakan segera dengan ancaman pemblokiran sering digunakan untuk memicu keputusan terburu-buru.'),
        const _TipTile(icon: Icons.verified_user_outlined, title: 'Verifikasi lewat kanal resmi', content: 'Hubungi lembaga atau pengirim melalui nomor resmi yang kamu cari secara mandiri, bukan melalui nomor atau tautan di pesan mencurigakan.'),
        const _TipTile(icon: Icons.security_outlined, title: 'Aktifkan keamanan akun', content: 'Gunakan kata sandi unik, autentikasi dua faktor, dan pembaruan sistem secara rutin.'),
        const SizedBox(height: 22),
        const InfoStrip(icon: Icons.shield_outlined, text: 'Konten edukasi Mivvi Secure bersifat umum dan tidak menggantikan pemeriksaan oleh ahli keamanan siber.'),
      ]);
}

class _TipTile extends StatelessWidget {
  const _TipTile({required this.icon, required this.title, required this.content});
  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(color: Palette.surface, borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            shape: const Border(),
            collapsedShape: const Border(),
            iconColor: Palette.teal,
            collapsedIconColor: Palette.muted,
            leading: Icon(icon, color: Palette.purple),
            title: Text(title, style: const TextStyle(color: Palette.white, fontSize: 14, fontWeight: FontWeight.w700)),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            children: [Text(content, style: const TextStyle(color: Palette.muted, fontSize: 13, height: 1.6))],
          ),
        ),
      );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.store});
  final DemoStore store;

  Future<void> _clear(BuildContext context) async {
    final confirm = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Hapus seluruh riwayat?'),
      content: const Text('Semua hasil pemeriksaan selama sesi ini akan dihapus.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Batal')),
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Ya, hapus')),
      ],
    ));
    if (confirm == true) store.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: Palette.bg, title: const Text('Pengaturan & privasi')),
        body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: ListView(padding: const EdgeInsets.all(20), children: [
          const SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [BrandMark(), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mivvi Secure', style: TextStyle(color: Palette.white, fontWeight: FontWeight.w900, fontSize: 18)),
              Text('Versi 2.0 · Demo edukasi', style: TextStyle(color: Palette.muted, fontSize: 12)),
            ]))]),
            SizedBox(height: 19),
            InfoStrip(icon: Icons.science_outlined, text: 'Mode demo: tidak ada listener notifikasi Android, antivirus, pemblokiran, koneksi server, atau pemantauan otomatis.'),
          ])),
          const SizedBox(height: 23),
          const SectionTitle(title: 'Data & kontrol'),
          const SizedBox(height: 10),
          SurfaceCard(child: Column(children: [
            ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.restore, color: Palette.teal), title: const Text('Pulihkan pesan contoh'), subtitle: const Text('Tambahkan kembali contoh demonstrasi'), onTap: () {
              store.loadExamples();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesan contoh sudah dimuat.')));
            }),
            const Divider(),
            ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.delete_outline, color: Palette.red), title: const Text('Hapus riwayat sesi'), subtitle: const Text('Menghapus semua contoh dan hasil analisis'), onTap: () => _clear(context)),
          ])),
          const SizedBox(height: 23),
          const SectionTitle(title: 'Tentang analisis'),
          const SizedBox(height: 10),
          const SurfaceCard(child: Text('Mivvi menggunakan daftar indikator berbasis aturan (rule-based), misalnya permintaan OTP, tautan dipersingkat, dan tekanan waktu. Skor hanya penanda edukatif, bukan tingkat kepastian bahwa pesan berbahaya. Seluruh data disimpan di memori aplikasi dan hilang saat aplikasi ditutup atau dimulai ulang. Tidak ada layanan backend yang terhubung.', style: TextStyle(color: Palette.muted, fontSize: 13, height: 1.65))),
        ])))),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(children: [
        const Icon(Icons.inbox_outlined, size: 40, color: Palette.purple),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Palette.muted, fontSize: 13, height: 1.5)),
      ]));
}

class InfoStrip extends StatelessWidget {
  const InfoStrip({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Palette.purple.withOpacity(.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Palette.purple.withOpacity(.19)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Palette.purple, size: 18),
          const SizedBox(width: 9),
          Expanded(child: Text(text, style: const TextStyle(color: Palette.muted, fontSize: 12, height: 1.5))),
        ]),
      );
}
