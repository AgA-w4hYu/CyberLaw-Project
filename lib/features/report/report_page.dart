import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/report_model.dart';
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
  String _lastTicketId = '';
  String? _evidencePath;

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

  Future<void> _pickEvidence() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'txt'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _evidencePath = result.files.single.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memilih file'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis kejahatan terlebih dahulu'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    if (_descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskripsi tidak boleh kosong'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final reportsBox = await Hive.openBox(AppConstants.hiveBoxReports);
      final ticketId = generateTicketId();

      final report = ReportModel(
        id: 'report-${DateTime.now().millisecondsSinceEpoch}',
        ticketId: ticketId,
        type: _selectedType!,
        description: _descCtrl.text,
        location: _locationCtrl.text,
        evidencePath: _evidencePath,
        timestamp: DateTime.now(),
      );

      // Save report to Hive
      await reportsBox.put(report.id, report.toJson());

      setState(() {
        _loading = false;
        _submitted = true;
        _lastTicketId = ticketId;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan laporan. Silakan coba lagi.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessView(
        ticketId: _lastTicketId,
        onDone: () {
          setState(() {
            _submitted = false;
            _selectedType = null;
            _descCtrl.clear();
            _locationCtrl.clear();
            _evidencePath = null;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LAPORKAN KEJAHATAN'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.history, color: AppTheme.primary, size: 18),
            label: const Text(
              'Riwayat',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => context.push(AppConstants.routeReportHistory),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Honest disclaimer banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Laporan disimpan di perangkat Anda. Untuk melapor resmi ke pihak berwenang, kunjungi LAPOR!',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse('https://www.lapor.go.id');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.open_in_new, color: AppTheme.background, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Buka LAPOR! (lapor.go.id)',
                            style: GoogleFonts.orbitron(
                              color: AppTheme.background,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),

            const Text(
              'JENIS KEJAHATAN',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedType != null ? AppTheme.primary : AppTheme.border,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: AppTheme.surfaceVariant,
                  hint: const Text(
                    'Pilih jenis kejahatan...',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                  items: _reportTypes
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

            const Text(
              'DESKRIPSI',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            CyberTextField(
              label: 'Ceritakan kejadian secara rinci...',
              controller: _descCtrl,
              maxLines: 5,
              minLines: 4,
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 16),

            const Text(
              'LOKASI (OPSIONAL)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            CyberTextField(
              label: 'Kota / Platform (contoh: Jakarta, Instagram)',
              controller: _locationCtrl,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 20),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),

            // Evidence upload — now functional
            GestureDetector(
              onTap: _pickEvidence,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _evidencePath != null
                      ? AppTheme.secondary.withOpacity(0.1)
                      : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _evidencePath != null
                        ? AppTheme.secondary
                        : AppTheme.border,
                  ),
                ),
                child: _evidencePath != null
                    ? Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppTheme.secondary, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bukti terlampir',
                                  style: TextStyle(
                                    color: AppTheme.secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _evidencePath!.split('/').last,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 18),
                            onPressed: () => setState(() => _evidencePath = null),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Icon(Icons.upload_file, color: AppTheme.textSecondary, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'Unggah Bukti (Screenshot / File)',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                          ),
                          const Text(
                            'Ketuk untuk memilih file (jpg, png, pdf, txt)',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
              ),
            ).animate().fadeIn(delay: 250.ms),
            const SizedBox(height: 28),

            NeonButton(
              label: 'SIMPAN LAPORAN',
              width: double.infinity,
              isLoading: _loading,
              onPressed: _submit,
              color: AppTheme.accent,
              useGradient: false,
              icon: const Icon(Icons.save, size: 16, color: Colors.white),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String ticketId;
  final VoidCallback onDone;

  const _SuccessView({required this.ticketId, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LAPORAN TERSIMPAN')),
      body: Center(
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
              Text(
                'LAPORAN TERSIMPAN',
                style: GoogleFonts.orbitron(
                  color: AppTheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Laporan Anda telah disimpan di perangkat ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Nomor Tiket: $ticketId',
                style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Honest reminder
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Untuk melapor resmi, kunjungi LAPOR! (lapor.go.id) atau hubungi pihak berwenang setempat.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              NeonButton(
                label: 'BUAT LAPORAN BARU',
                width: double.infinity,
                onPressed: onDone,
                color: AppTheme.primary,
                useGradient: false,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push(AppConstants.routeReportHistory),
                child: const Text(
                  'Lihat Riwayat Laporan',
                  style: TextStyle(color: AppTheme.secondary, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
