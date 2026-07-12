import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class HashGeneratorPage extends StatefulWidget {
  const HashGeneratorPage({super.key});

  @override
  State<HashGeneratorPage> createState() => _HashGeneratorPageState();
}

class _HashGeneratorPageState extends State<HashGeneratorPage> {
  final _ctrl = TextEditingController();

  String _md5Hash = '';
  String _sha1Hash = '';
  String _sha256Hash = '';
  bool _generated = false;

  void _generate() {
    final text = _ctrl.text;
    if (text.isEmpty) return;
    final bytes = utf8.encode(text);
    setState(() {
      _md5Hash = md5.convert(bytes).toString();
      _sha1Hash = sha1.convert(bytes).toString();
      _sha256Hash = sha256.convert(bytes).toString();
      _generated = true;
    });
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hash disalin!'), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HASH GENERATOR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate hash kriptografis dari teks menggunakan algoritma MD5, SHA1, dan SHA256.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
            CyberTextField(
              label: 'Teks input',
              hint: 'Masukkan teks untuk di-hash...',
              controller: _ctrl,
              maxLines: 3,
              prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 48), child: Icon(Icons.text_snippet, color: AppTheme.textSecondary, size: 20)),
            ),
            const SizedBox(height: 16),
            NeonButton(
              label: 'GENERATE HASH',
              width: double.infinity,
              onPressed: _generate,
              icon: const Icon(Icons.fingerprint, size: 18, color: AppTheme.background),
            ),
            const SizedBox(height: 24),
            if (_generated) ...[
              _HashResult(algo: 'MD5', hash: _md5Hash, color: AppTheme.warning, onCopy: () => _copy(_md5Hash))
                  .animate().fadeIn(delay: 50.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _HashResult(algo: 'SHA-1', hash: _sha1Hash, color: AppTheme.accent, onCopy: () => _copy(_sha1Hash))
                  .animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _HashResult(algo: 'SHA-256', hash: _sha256Hash, color: AppTheme.primary, onCopy: () => _copy(_sha256Hash))
                  .animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_outlined, color: AppTheme.warning, size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'MD5 dan SHA-1 dianggap tidak aman untuk kriptografi modern. Gunakan SHA-256 atau lebih tinggi.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HashResult extends StatelessWidget {
  final String algo;
  final String hash;
  final Color color;
  final VoidCallback onCopy;

  const _HashResult({required this.algo, required this.hash, required this.color, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(algo, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              GestureDetector(
                onTap: onCopy,
                child: Row(
                  children: [
                    Icon(Icons.copy, color: color, size: 14),
                    const SizedBox(width: 4),
                    Text('Salin', style: TextStyle(color: color, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hash,
            style: GoogleFonts.sourceCodePro(
              color: AppTheme.textPrimary,
              fontSize: 12,
              letterSpacing: 0.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
