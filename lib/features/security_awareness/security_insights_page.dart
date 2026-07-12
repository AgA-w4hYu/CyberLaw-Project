import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/security_insight_model.dart';
import '../../widgets/section_header.dart';

class SecurityInsightsPage extends StatefulWidget {
  final String? initialQuery;
  const SecurityInsightsPage({super.key, this.initialQuery});

  @override
  State<SecurityInsightsPage> createState() => _SecurityInsightsPageState();
}

class _SecurityInsightsPageState extends State<SecurityInsightsPage> {
  static const String _allCategory = 'Semua';
  String _selectedCategory = _allCategory;
  late final TextEditingController _searchController = TextEditingController(text: widget.initialQuery ?? '');
  late String _searchQuery = widget.initialQuery ?? '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final categories = SecurityInsightData.insights
        .map((item) => item.category)
        .toSet()
        .toList()
      ..sort();
    return [_allCategory, ...categories];
  }

  List<SecurityInsightModel> get _filteredInsights {
    var list = SecurityInsightData.insights;

    if (_selectedCategory != _allCategory) {
      list = list.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      list = list.where((item) =>
          item.title.toLowerCase().contains(lowerQuery) ||
          item.summary.toLowerCase().contains(lowerQuery) ||
          item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final insights = _filteredInsights;

    return Scaffold(
      appBar: AppBar(title: const Text('WAWASAN & TIPS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HeroBanner().animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Checklist 15 Menit Pertama',
            subtitle: 'Langkah paling aman ketika akun, perangkat, atau data terasa sudah tidak terkendali.',
          ),
          const SizedBox(height: 14),
          ...SecurityInsightData.quickChecklist.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ChecklistTile(
                index: entry.key,
                text: entry.value,
              ).animate(delay: Duration(milliseconds: 120 + entry.key * 60)).fadeIn(),
            );
          }),
          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Cari kasus (mis: HP hilang, retas)...',
              hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppTheme.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary),
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'PILIH KASUS',
                style: GoogleFonts.orbitron(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(),
              Text(
                '${insights.length} panduan',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = category),
                    backgroundColor: AppTheme.surfaceVariant,
                    selectedColor: AppTheme.primary.withOpacity(0.18),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primary : AppTheme.border,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ...insights.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _InsightCard(
                insight: entry.value,
                index: entry.key,
                initiallyExpanded: insights.length == 1,
              ),
            );
          }),
          const SizedBox(height: 16),
          _SupportActionBox(
            onOpenReport: () => context.push(AppConstants.routeReport),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), AppTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_moon,
                  color: AppTheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Panduan awal untuk kasus nyata cybersecurity',
                  style: GoogleFonts.orbitron(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Fokus halaman ini adalah membantu user mengambil langkah yang aman saat akun diretas, HP hilang, terkena phishing, atau data pribadinya bocor.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accent.withOpacity(0.35)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.accent, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Panduan ini adalah langkah awal, bukan pengganti bantuan hukum, forensik, atau dukungan resmi platform.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  final int index;
  final String text;

  const _ChecklistTile({
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppTheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final SecurityInsightModel insight;
  final int index;

  final bool initiallyExpanded;
  const _InsightCard({
    required this.insight,
    required this.index,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: insight.color.withOpacity(0.22)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: insight.color,
          collapsedIconColor: insight.color,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: insight.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(insight.icon, color: insight.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: GoogleFonts.rajdhani(
                        color: AppTheme.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight.summary,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _Badge(
                  label: insight.urgencyLabel,
                  color: insight.color,
                ),
                const SizedBox(width: 8),
                _Badge(
                  label: insight.category,
                  color: AppTheme.surfaceVariant,
                  textColor: AppTheme.textSecondary,
                  borderColor: AppTheme.border,
                ),
              ],
            ),
          ),
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: insight.tags.map((tag) => _TagChip(tag: tag)).toList(),
            ),
            const SizedBox(height: 14),
            _ContentSection(
              title: 'Langkah yang disarankan',
              icon: Icons.bolt,
              color: insight.color,
              items: insight.firstResponseSteps,
            ),
            const SizedBox(height: 14),
            _ContentSection(
              title: 'Cara mencegah kejadian berulang',
              icon: Icons.shield,
              color: AppTheme.secondary,
              items: insight.preventionTips,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.balance, color: AppTheme.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      insight.legalGuidance,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 80 + index * 50)).fadeIn().slideY(
          begin: 0.05,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _ContentSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.orbitron(
                color: AppTheme.textPrimary,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right, color: color, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportActionBox extends StatelessWidget {
  final VoidCallback onOpenReport;

  const _SupportActionBox({
    required this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111C1A), AppTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.secondary.withOpacity(0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perlu susun kronologi insiden?',
            style: GoogleFonts.orbitron(
              color: AppTheme.secondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buka menu Laporkan untuk menyiapkan deskripsi awal, lokasi, dan bukti yang bisa dipakai saat melapor ke kanal resmi.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onOpenReport,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.neonGlow(AppTheme.secondary, spread: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: AppTheme.background, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Buka Form Laporan',
                    style: TextStyle(
                      color: AppTheme.background,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final Color? borderColor;

  const _Badge({
    required this.label,
    required this.color,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor = textColor ?? color;
    final resolvedBorderColor = borderColor ?? color.withOpacity(0.35);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: resolvedBorderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: resolvedTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
