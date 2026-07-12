import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../models/law_article_model.dart';
import '../../widgets/common_widgets.dart';

class LawArticleDetailPage extends StatelessWidget {
  final String articleId;

  const LawArticleDetailPage({super.key, required this.articleId});

  LawArticleModel? _findArticle() {
    try {
      return LawArticleData.articles.firstWhere((a) => a.id == articleId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = _findArticle();

    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ARTIKEL')),
        body: const Center(child: Text('Artikel tidak ditemukan', style: TextStyle(color: AppTheme.textSecondary))),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D2137), AppTheme.surface],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
                      ),
                      child: Text(article.category, style: const TextStyle(color: AppTheme.primary, fontSize: 11, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: GoogleFonts.orbitron(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tags
                Wrap(
                  spacing: 8,
                  children: article.tags.map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(color: AppTheme.primary, fontSize: 11)),
                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                    side: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
                    padding: EdgeInsets.zero,
                  )).toList(),
                ).animate().fadeIn(),
                const SizedBox(height: 20),

                // Summary box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(article.summary, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                CyberDivider(),
                const SizedBox(height: 20),

                // Markdown-style content
                _ArticleContent(markdown: article.content).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  final String markdown;
  const _ArticleContent({required this.markdown});

  List<Widget> _parseToWidgets() {
    final lines = markdown.trim().split('\n');
    final List<Widget> widgets = [];

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(line.substring(3), style: GoogleFonts.orbitron(color: AppTheme.primary, fontSize: 15, fontWeight: FontWeight.bold)),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(line.substring(4), style: GoogleFonts.rajdhani(color: AppTheme.secondary, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ));
      } else if (line.startsWith('**') && line.endsWith('**')) {
        final boldText = line.replaceAll('**', '');
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 2),
          child: Text(boldText, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
        ));
      } else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: AppTheme.primary, fontSize: 14)),
              Expanded(child: Text(line.substring(2), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.6))),
            ],
          ),
        ));
      } else if (line.startsWith('---')) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: AppTheme.border),
        ));
      } else if (line.startsWith('|')) {
        // Skip table lines — shown as plain text
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(line, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'monospace')),
        ));
      } else if (line.isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(line, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.7)),
        ));
      } else {
        widgets.add(const SizedBox(height: 6));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: _parseToWidgets(),
  );
}
