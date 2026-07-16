import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });
}

class MockAchievementData {
  static const List<Achievement> achievements = [
    Achievement(
      id: 'first-lesson',
      title: 'First Steps',
      description: 'Complete your first lesson',
      icon: Icons.school,
      color: Color(0xFF3B82F6),
      isUnlocked: true,
    ),
    Achievement(
      id: 'five-lessons',
      title: 'Knowledge Seeker',
      description: 'Complete 5 lessons',
      icon: Icons.menu_book,
      color: Color(0xFF10B981),
      isUnlocked: true,
    ),
    Achievement(
      id: 'first-ctf',
      title: 'CTF Rookie',
      description: 'Solve your first CTF challenge',
      icon: Icons.flag,
      color: Color(0xFF8B5CF6),
      isUnlocked: true,
    ),
    Achievement(
      id: 'three-ctf',
      title: 'Challenge Accepted',
      description: 'Solve 3 CTF challenges',
      icon: Icons.emoji_events,
      color: Color(0xFFF59E0B),
      isUnlocked: true,
    ),
    Achievement(
      id: 'streak-3',
      title: 'Getting Started',
      description: '3-day login streak',
      icon: Icons.local_fire_department,
      color: Color(0xFFF59E0B),
      isUnlocked: true,
    ),
    Achievement(
      id: 'streak-7',
      title: 'Week Warrior',
      description: '7-day login streak',
      icon: Icons.local_fire_department,
      color: Color(0xFFEF4444),
      isUnlocked: false,
    ),
    Achievement(
      id: 'first-tool',
      title: 'Tool Master',
      description: 'Use 5 different tools',
      icon: Icons.build_circle,
      color: Color(0xFF3B82F6),
      isUnlocked: true,
    ),
    Achievement(
      id: 'all-tools',
      title: 'Swiss Army Knife',
      description: 'Use all available tools',
      icon: Icons.build,
      color: Color(0xFF8B5CF6),
      isUnlocked: false,
    ),
    Achievement(
      id: 'first-post',
      title: 'Community Voice',
      description: 'Create your first community post',
      icon: Icons.forum,
      color: Color(0xFF10B981),
      isUnlocked: true,
    ),
    Achievement(
      id: 'ten-likes',
      title: 'Popular Opinion',
      description: 'Get 10 likes on your posts',
      icon: Icons.favorite,
      color: Color(0xFFEC4899),
      isUnlocked: false,
    ),
    Achievement(
      id: 'network-path',
      title: 'Network Guru',
      description: 'Complete the Network Security path',
      icon: Icons.language,
      color: Color(0xFF3B82F6),
      isUnlocked: false,
    ),
    Achievement(
      id: 'crypto-path',
      title: 'Crypto Master',
      description: 'Complete the Cryptography path',
      icon: Icons.vpn_key,
      color: Color(0xFF8B5CF6),
      isUnlocked: false,
    ),
    Achievement(
      id: 'linux-path',
      title: 'Linux Legend',
      description: 'Complete the Linux Fundamentals path',
      icon: Icons.terminal,
      color: Color(0xFF10B981),
      isUnlocked: false,
    ),
    Achievement(
      id: 'level-5',
      title: 'Level Up!',
      description: 'Reach level 5',
      icon: Icons.trending_up,
      color: Color(0xFF3B82F6),
      isUnlocked: true,
    ),
    Achievement(
      id: 'level-10',
      title: 'Double Digits',
      description: 'Reach level 10',
      icon: Icons.rocket_launch,
      color: Color(0xFF8B5CF6),
      isUnlocked: false,
    ),
    Achievement(
      id: 'streak-30',
      title: 'Unstoppable',
      description: '30-day login streak',
      icon: Icons.whatshot,
      color: Color(0xFFEF4444),
      isUnlocked: false,
    ),
  ];

  static List<Achievement> get unlocked =>
      achievements.where((a) => a.isUnlocked).toList();

  static List<Achievement> get locked =>
      achievements.where((a) => !a.isUnlocked).toList();
}
