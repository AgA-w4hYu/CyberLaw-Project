import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/report_model.dart';

class ReportHistoryPage extends StatefulWidget {
  const ReportHistoryPage({super.key});

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  List<ReportModel> _reports = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final reportsBox = await Hive.openBox(AppConstants.hiveBoxReports);
      final List<ReportModel> reports = [];
      for (final key in reportsBox.keys) {
        final data = reportsBox.get(key);
        if (data != null) {
          reports.add(ReportModel.fromJson(Map<String, dynamic>.from(data)));
        }
      }
      // Sort by timestamp, newest first
      reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      setState(() {
        _reports = reports;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Gagal memuat laporan. Silakan coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RIWAYAT LAPORAN')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _errorMessage != null
              ? _buildErrorState()
              : _reports.isEmpty
                  ? _buildEmptyState()
                  : _buildReportList(),
    );
  }

  Widget _buildErrorState() {
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
                color: AppTheme.error.withOpacity(0.1),
                border: Border.all(color: AppTheme.error.withOpacity(0.4)),
              ),
              child: const Icon(Icons.error_outline, color: AppTheme.error, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Terjadi Kesalahan',
              style: GoogleFonts.orbitron(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Terjadi kesalahan tidak diketahui.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _loadReports,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: AppTheme.background, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
                color: AppTheme.surfaceVariant,
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.description_outlined, color: AppTheme.textSecondary, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum Ada Laporan',
              style: GoogleFonts.orbitron(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Laporan yang Anda buat akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return _ReportCard(report: report, index: index);
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportModel report;
  final int index;

  const _ReportCard({required this.report, required this.index});

  String _formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dt);
  }

  Color _getTypeColor() {
    if (report.type.contains('Phishing') || report.type.contains('Penipuan')) {
      return AppTheme.accent;
    } else if (report.type.contains('Malware') || report.type.contains('Ransomware')) {
      return AppTheme.error;
    } else if (report.type.contains('Data Pribadi')) {
      return AppTheme.warning;
    } else if (report.type.contains('Peretasan')) {
      return const Color(0xFFAB00FF);
    }
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: typeColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: typeColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    report.ticketId,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(report.timestamp),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Type
            Row(
              children: [
                Icon(Icons.category, color: typeColor, size: 14),
                const SizedBox(width: 6),
                Text(
                  report.type,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              report.description,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Location
            if (report.location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.location,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Evidence indicator
            if (report.evidencePath != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attach_file, color: AppTheme.secondary, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      report.evidencePath!.split('/').last,
                      style: const TextStyle(color: AppTheme.secondary, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 60 * index))
          .fadeIn()
          .slideY(begin: 0.08),
    );
  }
}
