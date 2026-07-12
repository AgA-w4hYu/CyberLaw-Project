import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/common_widgets.dart';

class Base64ToolPage extends StatefulWidget {
  const Base64ToolPage({super.key});

  @override
  State<Base64ToolPage> createState() => _Base64ToolPageState();
}

class _Base64ToolPageState extends State<Base64ToolPage> {
  final _ctrl = TextEditingController();
  String _result = '';
  String? _error;
  bool _isEncoded = false;

  void _encode() {
    final text = _ctrl.text;
    if (text.isEmpty) return;
    setState(() {
      _error = null;
      _result = base64.encode(utf8.encode(text));
      _isEncoded = true;
    });
  }

  void _decode() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    try {
      final decoded = utf8.decode(base64.decode(text));
      setState(() {
        _error = null;
        _result = decoded;
        _isEncoded = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Input bukan string Base64 yang valid';
        _result = '';
      });
    }
  }

  void _copyResult() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hasil disalin ke clipboard'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BASE64 TOOL')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encode teks ke Base64, atau decode string Base64 kembali ke teks.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
            CyberTextField(
              label: 'Teks input',
              hint: 'Masukkan teks atau string Base64...',
              controller: _ctrl,
              maxLines: 4,
              prefixIcon: const Padding(padding: EdgeInsets.only(bottom: 72), child: Icon(Icons.text_fields, color: AppTheme.textSecondary, size: 20)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    label: 'ENCODE',
                    onPressed: _encode,
                    color: AppTheme.primary,
                    useGradient: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    label: 'DECODE',
                    onPressed: _decode,
                    color: AppTheme.secondary,
                    useGradient: false,
                  ),
                ),
              ],
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
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
                    const SizedBox(width: 8),
                    Text(_error!, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                  ],
                ),
              ).animate().shake(),
            if (_result.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEncoded ? 'HASIL ENCODE' : 'HASIL DECODE',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.primary, size: 18),
                    onPressed: _copyResult,
                    tooltip: 'Salin',
                  ),
                ],
              ),
              TerminalText(text: _result, color: _isEncoded ? AppTheme.primary : AppTheme.secondary)
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.2),
            ],
          ],
        ),
      ),
    );
  }
}
