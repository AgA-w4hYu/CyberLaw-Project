import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  static const _posts = [
    _Post(
      username: 'xNoobHunter',
      avatar: 'XN',
      avatarColor: Color(0xFF00F0FF),
      time: '2 jam lalu',
      title: 'Tips SQL Injection Testing – Untuk Bug Bounty Hunter',
      body: 'Halo teman-teman! Mau berbagi pengalaman saya saat hunting bug di program bug bounty publik. SQLi masih jadi temuan favorit, terutama di endpoint yang tidak sanitasi input dengan benar...',
      tags: ['Bug Bounty', 'SQLi', 'Tips'],
      likes: 142,
      comments: 34,
    ),
    _Post(
      username: 'CyberLawyer_ID',
      avatar: 'CL',
      avatarColor: Color(0xFF00FF9C),
      time: '5 jam lalu',
      title: 'Penjelasan Pasal 30 UU ITE: Batas Ethical Hacking',
      body: 'Banyak yang tanya tentang batas legal ethical hacking di Indonesia. Simpelnya: kamu butuh izin tertulis dari pemilik sistem. Tanpa itu, apapun alasannya, bisa kena Pasal 30...',
      tags: ['UU ITE', 'Legal', 'Ethical Hacking'],
      likes: 287,
      comments: 61,
    ),
    _Post(
      username: 'r3versed_m1nd',
      avatar: 'RM',
      avatarColor: Color(0xFFFF006E),
      time: '1 hari lalu',
      title: 'Write-up: Caesar Cipher CTF di Cyber Lab!',
      body: 'Baru selesai solve crypto-01 di app ini. Challenge-nya seru banget! Spoiler dikit: key shift-nya 3, jadi tinggal ROT-3 aja. Tapi ada yang bisa solve crypto-02 juga?',
      tags: ['CTF', 'Write-up', 'Crypto'],
      likes: 98,
      comments: 22,
    ),
    _Post(
      username: 'sec0ps_gurl',
      avatar: 'SG',
      avatarColor: Color(0xFFFFD60A),
      time: '2 hari lalu',
      title: 'REVIEW: Buku "The Art of Invisibility" by Kevin Mitnick',
      body: 'Baru selesai baca buku ini. Kevin Mitnick menjelaskan dengan lugas bagaimana privasi digital kita terus terancam setiap hari. Wajib baca untuk semua yang peduli privasi online...',
      tags: ['Book', 'Privasi', 'Rekomendasi'],
      likes: 203,
      comments: 45,
    ),
    _Post(
      username: '0xH4ck3r_Pro',
      avatar: '0X',
      avatarColor: Color(0xFFAB00FF),
      time: '3 hari lalu',
      title: 'Setup Lab Home Hacking dengan VirtualBox + Kali Linux',
      body: 'Tutorial lengkap setup home lab untuk belajar ethical hacking dengan aman. Pakai VirtualBox + Kali Linux + DVWA sebagai target. Aman, legal, dan gratis...',
      tags: ['Tutorial', 'Kali Linux', 'Lab Setup'],
      likes: 421,
      comments: 89,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KOMUNITAS'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.group_add, color: AppTheme.primary, size: 18),
            label: const Text('JOIN', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil bergabung dengan Komunitas!'))),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.secondary),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur buat post segera hadir'))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Semua', 'CTF', 'Bug Bounty', 'Tutorial', 'Legal', 'Tools'].map((tag) {
                final isSelected = tag == 'Semua';
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {},
                    backgroundColor: AppTheme.surfaceVariant,
                    selectedColor: AppTheme.primary.withOpacity(0.2),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(color: isSelected ? AppTheme.primary : AppTheme.textSecondary, fontSize: 12),
                    side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                    padding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          ..._posts.asMap().entries.map((e) => _PostCard(post: e.value, index: e.key)),
        ],
      ),
    );
  }
}

class _Post {
  final String username;
  final String avatar;
  final Color avatarColor;
  final String time;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int comments;

  const _Post({
    required this.username, required this.avatar, required this.avatarColor,
    required this.time, required this.title, required this.body,
    required this.tags, required this.likes, required this.comments,
  });
}

class _PostCard extends StatefulWidget {
  final _Post post;
  final int index;
  const _PostCard({required this.post, required this.index});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: p.avatarColor.withOpacity(0.2),
                  radius: 18,
                  child: Text(p.avatar, style: TextStyle(color: p.avatarColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.username, style: GoogleFonts.rajdhani(color: p.avatarColor, fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(p.time, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: AppTheme.textSecondary, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(p.title, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(p.body, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            // Tags
            Wrap(
              spacing: 6,
              children: p.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: Text('#$tag', style: const TextStyle(color: AppTheme.primary, fontSize: 10)),
              )).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 10),
            // Actions
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Row(
                    children: [
                      Icon(_liked ? Icons.favorite : Icons.favorite_border, color: _liked ? AppTheme.accent : AppTheme.textSecondary, size: 18),
                      const SizedBox(width: 4),
                      Text('${p.likes + (_liked ? 1 : 0)}', style: TextStyle(color: _liked ? AppTheme.accent : AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppTheme.surface,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Komentar (${p.comments})', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              const Expanded(
                                child: Center(child: Text('Belum ada komentar yang dapat dimuat.', style: TextStyle(color: AppTheme.textSecondary))),
                              ),
                              TextField(
                                style: const TextStyle(color: AppTheme.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Tulis komentar...',
                                  hintStyle: const TextStyle(color: AppTheme.textSecondary),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send, color: AppTheme.primary),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Komentar terkirim!')));
                                    },
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.surfaceVariant,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: AppTheme.textSecondary, size: 16),
                      const SizedBox(width: 4),
                      Text('${p.comments}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.share_outlined, color: AppTheme.textSecondary, size: 16),
              ],
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: 80 * widget.index)).fadeIn().slideY(begin: 0.1),
    );
  }
}
