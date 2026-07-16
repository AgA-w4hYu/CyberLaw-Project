import 'package:flutter/material.dart';

class CyberNews {
  final String id;
  final String title;
  final String summary;
  final String source;
  final String timeAgo;
  final IconData icon;
  final Color color;

  const CyberNews({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.timeAgo,
    required this.icon,
    required this.color,
  });
}

class MockNewsData {
  static const List<CyberNews> news = [
    CyberNews(
      id: 'news-1',
      title: 'New Phishing Campaign Targets Indonesian Banks',
      summary: 'A sophisticated phishing campaign is targeting customers of major Indonesian banks using fake SMS and email messages.',
      source: 'BSSN Alert',
      timeAgo: '2 hours ago',
      icon: Icons.warning_amber,
      color: Color(0xFFEF4444),
    ),
    CyberNews(
      id: 'news-2',
      title: 'CVE-2024-3094: Critical Vulnerability in XZ Utils',
      summary: 'A backdoor was discovered in XZ Utils compression library affecting Linux systems worldwide.',
      source: 'NVD',
      timeAgo: '6 hours ago',
      icon: Icons.bug_report,
      color: Color(0xFFF59E0B),
    ),
    CyberNews(
      id: 'news-3',
      title: 'Indonesia\'s New Data Protection Law Takes Effect',
      summary: 'UU Perlindungan Data Pribadi (UU PDP) enforcement begins with strict penalties for data breaches.',
      source: 'Kominfo',
      timeAgo: '1 day ago',
      icon: Icons.shield,
      color: Color(0xFF10B981),
    ),
    CyberNews(
      id: 'news-4',
      title: 'HackToday 2024 CTF Competition Announced',
      summary: 'Indonesia\'s largest CTF competition returns with prizes worth over IDR 100 million.',
      source: 'HackToday',
      timeAgo: '2 days ago',
      icon: Icons.emoji_events,
      color: Color(0xFF8B5CF6),
    ),
    CyberNews(
      id: 'news-5',
      title: 'Ransomware Attack Disrupts Healthcare Services',
      summary: 'A major ransomware attack has affected healthcare providers, highlighting the need for better security.',
      source: 'CyberSec News',
      timeAgo: '3 days ago',
      icon: Icons.local_hospital,
      color: Color(0xFFEF4444),
    ),
    CyberNews(
      id: 'news-6',
      title: 'OWASP Releases Updated Top 10 for 2024',
      summary: 'The OWASP Foundation has published their latest Top 10 web application security risks.',
      source: 'OWASP',
      timeAgo: '4 days ago',
      icon: Icons.web,
      color: Color(0xFF3B82F6),
    ),
  ];
}
