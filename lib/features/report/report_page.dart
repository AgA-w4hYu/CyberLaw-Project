import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String? _selectedType;
  bool _loading = false;
  bool _submitted = false;

  final List<String> _reportTypes = [
    'Phishing / Penipuan Online',
    'Penyebaran Malware / Ransomware',
    'Pelanggaran Data Pribadi',
    'Cyberbullying / Ujaran Kebencian',
    'Penyelundupan Konten Ilegal',
    'Peretasan Sistem',
    'Hoaks / Disinformasi',
    'Lainnya',
  ];

  @override
  void dispose() {
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis kejahatan terlebih dahulu'), backgroundColor: AppTheme.error),
      );
      return;
    }
    if (_descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deskripsi tidak boleh kosong'), backgroundColor: AppTheme.error),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() { _loading = false; _submitted = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LAPORKAN KEJAHATAN')),
      body: _submitted ? _SuccessView() : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.accent, size: 18),
                  SizedBox(width: 10),
                  Expanded(child: Text('Laporan kamu akan dikirimkan ke Badan Siber dan Sandi Negara (BSSN)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4))),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            const Text('JENIS KEJAHATAN', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedType != null ? AppTheme.primary : AppTheme.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: AppTheme.surfaceVariant,
                  hint: const Text('Pilih jenis kejahatan...', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  items: _reportTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)))).toList(),
                  onChanged: (v) => setState(() => _selectedType = v),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

            const Text('DESKRIPSI', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 10),
            CyberTextField(
              label: 'Ceritakan kejadian secara rinci...',
              controller: _descCtrl,
              maxLines: 5,
              minLines: 4,
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 16),

            const Text('LOKASI (OPSIONAL)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 10),
            CyberTextField(
              label: 'Kota / Platform (contoh: Jakarta, Instagram)',
              controller: _locationCtrl,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 20),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),

            // Evidence upload (placeholder)
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur upload bukti segera hadir'))),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.upload_file, color: AppTheme.textSecondary, size: 32),
                    const SizedBox(height: 8),
                    const Text('Unggah Bukti (Screenshot / File)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    const Text('Ketuk untuk memilih file', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 250.ms),
            const SizedBox(height: 28),

            NeonButton(
              label: 'KIRIM LAPORAN',
              width: double.infinity,
              isLoading: _loading,
              onPressed: _submit,
              color: AppTheme.accent,
              useGradient: false,
              icon: const Icon(Icons.send, size: 16, color: Colors.white),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withOpacity(0.1),
                boxShadow: AppTheme.neonGlow(AppTheme.secondary),
              ),
              child: const Icon(Icons.check_circle, color: AppTheme.secondary, size: 64),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text('LAPORAN TERKIRIM', style: GoogleFonts.orbitron(color: AppTheme.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Terima kasih telah melaporkan. Tim kami akan meninjau laporan Anda dalam 1x24 jam.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text('Nomor Tiket: RPT-2024-03987', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
