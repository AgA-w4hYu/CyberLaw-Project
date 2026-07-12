import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/common_widgets.dart';

class BinaryDecoderPage extends StatefulWidget {
  const BinaryDecoderPage({super.key});

  @override
  State<BinaryDecoderPage> createState() => _BinaryDecoderPageState();
}

class _BinaryDecoderPageState extends State<BinaryDecoderPage> {
  final _ctrl = TextEditingController();
  String _result = '';
  String? _error;

  void _decode() {
    final input = _ctrl.text.trim().replaceAll('\n', ' ');
    if (input.isEmpty) return;

    final groups = input.split(RegExp(r'\s+'));
    final buffer = StringBuffer();
    String? err;

    for (final group in groups) {
      final clean = group.replaceAll(RegExp(r'[^01]'), '');
      if (clean.isEmpty) continue;
      if (clean.length != 8) {
        err = 'Setiap group harus terdiri dari 8 bit. Group "$group" tidak valid.';
        break;
      }
      final charCode = int.parse(clean, radix: 2);
      buffer.writeCharCode(charCode);
    }

    setState(() {
      _error = err;
      _result = err == null ? buffer.toString() : '';
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _result));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hasil disalin!'), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BINARY DECODER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Konversi string binary (8-bit per karakter, dipisahkan spasi) ke teks ASCII.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            // Example
            GestureDetector(
              onTap: () {
                _ctrl.text = '01001000 01100101 01101100 01101100 01101111';
                _decode();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contoh Input:', style: TextStyle(color: AppTheme.primary, fontSize: 12, letterSpacing: 1)),
                    SizedBox(height: 4),
                    Text(
                      '01001000 01100101 01101100 01101100 01101111',
                      style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontFamily: 'monospace'),
                    ),
                    SizedBox(height: 4),
                    Text('(Ketuk area ini untuk mengisi otomatis)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CyberTextField(
              label: 'Binary Input',
              hint: '01001000 01100101 ...',
              controller: _ctrl,
              maxLines: 4,
              prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 72), child: Icon(Icons.memory, color: AppTheme.textSecondary, size: 20)),
            ),
            const SizedBox(height: 16),
            NeonButton(
              label: 'DECODE',
              width: double.infinity,
              onPressed: _decode,
              color: AppTheme.warning,
              useGradient: false,
              icon: const Icon(Icons.translate, size: 18, color: AppTheme.background),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.error),
                ),
                child: Text(_error!, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
              ).animate().shake(),
            if (_result.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('HASIL ASCII', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
                  IconButton(icon: const Icon(Icons.copy, color: AppTheme.warning, size: 18), onPressed: _copy),
                ],
              ),
              TerminalText(text: _result, color: AppTheme.warning).animate().fadeIn().slideY(begin: 0.2),
            ],
          ],
        ),
      ),
    );
  }
}
