import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/tool_model.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';

void _showToolSheet(BuildContext context, ToolModel tool) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(tool.icon, color: tool.color, size: 28),
              const SizedBox(width: 12),
              Text(
                tool.name,
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tool.description,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    ),
  );
}

class ToolkitPage extends StatefulWidget {
  const ToolkitPage({super.key});

  @override
  State<ToolkitPage> createState() => _ToolkitPageState();
}

class _ToolkitPageState extends State<ToolkitPage> {
  final _searchCtrl = TextEditingController();
  final Set<String> _favorites = {'hash-gen', 'password-strength', 'base64'};
  final List<String> _recentlyUsed = ['base64', 'hash-gen', 'phishing'];
  bool _showSearch = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ToolModel> get _filteredTools {
    final query = _searchCtrl.text.toLowerCase().trim();
    if (query.isEmpty) return [];
    return MockToolData.tools.where((t) {
      return t.name.toLowerCase().contains(query) ||
          t.description.toLowerCase().contains(query) ||
          t.categoryLabel.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search tools...',
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              )
            : Text(
                'Toolkit',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _showSearch ? Icons.close : Icons.search,
              color: AppColors.textTertiary,
            ),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchCtrl.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _showSearch
          ? _buildSearchResults()
          : _buildToolkitContent(),
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredTools;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              color: AppColors.textTertiary,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No tools found',
              style: AppTypography.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.page),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _ToolItem(tool: results[i], isFavorite: _favorites.contains(results[i].id)),
    );
  }

  Widget _buildToolkitContent() {
    final popular = MockToolData.popular;
    final favorites = MockToolData.tools
        .where((t) => _favorites.contains(t.id))
        .toList();
    final recently = MockToolData.tools
        .where((t) => _recentlyUsed.contains(t.id))
        .toList();
    final categories = ToolCategory.values;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [
        // Header
        Text(
          '${MockToolData.tools.length} tools available',
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Favorites
        if (favorites.isNotEmpty) ...[
          SectionHeader(title: 'Favorites'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) => _CompactToolCard(
                tool: favorites[i],
                isFavorite: true,
                onToggleFavorite: () {
                  setState(() => _favorites.remove(favorites[i].id));
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],

        // Recently Used
        if (recently.isNotEmpty) ...[
          SectionHeader(title: 'Recently Used'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recently.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) => _CompactToolCard(tool: recently[i]),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],

        // Popular
        SectionHeader(title: 'Popular'),
        const SizedBox(height: AppSpacing.md),
        ...popular.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ToolItem(
                tool: t,
                isFavorite: _favorites.contains(t.id),
                onToggleFavorite: () {
                  setState(() {
                    if (_favorites.contains(t.id)) {
                      _favorites.remove(t.id);
                    } else {
                      _favorites.add(t.id);
                    }
                  });
                },
              ),
            )),
        const SizedBox(height: AppSpacing.xxl),

        // Categories
        SectionHeader(title: 'Categories'),
        const SizedBox(height: AppSpacing.md),
        ...categories.map((cat) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _CategorySection(
                category: cat,
                tools: MockToolData.getByCategory(cat),
                favorites: _favorites,
                onToggleFavorite: (id) {
                  setState(() {
                    if (_favorites.contains(id)) {
                      _favorites.remove(id);
                    } else {
                      _favorites.add(id);
                    }
                  });
                },
              ),
            )),
        const SizedBox(height: AppSpacing.section),
      ],
    );
  }
}

// ── Compact Tool Card (for horizontal scrolling sections) ──
class _CompactToolCard extends StatelessWidget {
  final ToolModel tool;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const _CompactToolCard({
    required this.tool,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 140,
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: tool.color.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(tool.icon, color: tool.color, size: 20),
                const Spacer(),
                if (onToggleFavorite != null)
                  GestureDetector(
                    onTap: onToggleFavorite,
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color:
                          isFavorite ? AppColors.warning : AppColors.textTertiary,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              tool.name,
              style: AppTypography.buttonSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tool Item (vertical list) ──
class _ToolItem extends StatelessWidget {
  final ToolModel tool;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const _ToolItem({
    required this.tool,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: GlassCard(
        padding: AppSpacing.cardPaddingCompact,
        borderColor: tool.color.withOpacity(0.15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tool.color.withOpacity(0.1),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(tool.icon, color: tool.color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    tool.description,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onToggleFavorite != null)
              GestureDetector(
                onTap: onToggleFavorite,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite
                        ? AppColors.warning
                        : AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category Section ──
class _CategorySection extends StatelessWidget {
  final ToolCategory category;
  final List<ToolModel> tools;
  final Set<String> favorites;
  final void Function(String id) onToggleFavorite;

  const _CategorySection({
    required this.category,
    required this.tools,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    IconData icon;

    switch (category) {
      case ToolCategory.encoding:
        title = 'Encoding';
        icon = Icons.code;
      case ToolCategory.hashing:
        title = 'Hashing';
        icon = Icons.fingerprint;
      case ToolCategory.password:
        title = 'Password';
        icon = Icons.lock;
      case ToolCategory.networking:
        title = 'Networking';
        icon = Icons.dns;
      case ToolCategory.osint:
        title = 'OSINT';
        icon = Icons.search;
      case ToolCategory.utilities:
        title = 'Utilities';
        icon = Icons.build;
    }

    return GlassCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${tools.length} tools',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...tools.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ToolItem(
                  tool: t,
                  isFavorite: favorites.contains(t.id),
                  onToggleFavorite: () => onToggleFavorite(t.id),
                ),
              )),
        ],
      ),
    );
  }
}
