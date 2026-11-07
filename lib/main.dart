import 'package:flutter/material.dart';
import 'core/demo_store.dart';
import 'ui/app_theme.dart';
import 'ui/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MivviApp());
}

class MivviApp extends StatefulWidget {
  const MivviApp({super.key});

  @override
  State<MivviApp> createState() => _MivviAppState();
}

class _MivviAppState extends State<MivviApp> {
  final DemoStore store = DemoStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mivvi Secure',
      theme: createTheme(),
      home: MivviHome(store: store),
    );
  }
}
