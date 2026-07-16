import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String username;
  final String avatarInitials;
  final Color avatarColor;
  final String timeAgo;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int comments;
  final bool isMentorPick;
  final bool isTrending;

  const CommunityPost({
    required this.id,
    required this.username,
    required this.avatarInitials,
    required this.avatarColor,
    required this.timeAgo,
    required this.title,
    required this.body,
    required this.tags,
    this.likes = 0,
    this.comments = 0,
    this.isMentorPick = false,
    this.isTrending = false,
  });
}

class MockCommunityData {
  static const List<CommunityPost> posts = [
    CommunityPost(
      id: 'post-1',
      username: 'CyberWizard_ID',
      avatarInitials: 'CW',
      avatarColor: Color(0xFF3B82F6),
      timeAgo: '2 hours ago',
      title: 'SQL Injection Tips for Bug Bounty Hunters',
      body: 'Just hit my 10th SQLi find this month! Here are my top tips: look for reflected parameters in URLs, test all input fields, and always try time-based blind injection when error-based fails. Remember: every parameter is a potential attack vector.',
      tags: ['Bug Bounty', 'SQLi', 'Tips'],
      likes: 234,
      comments: 56,
      isTrending: true,
    ),
    CommunityPost(
      id: 'post-2',
      username: 'SecureLaw_ID',
      avatarInitials: 'SL',
      avatarColor: Color(0xFF10B981),
      timeAgo: '5 hours ago',
      title: 'Understanding UU ITE Article 30: The Legal Limits of Ethical Hacking',
      body: 'Many ask where the legal line is for ethical hacking in Indonesia. Article 30 is clear: unauthorized access to any computer system is illegal. Always get written authorization before testing. Even with good intentions, without permission it\'s still a crime.',
      tags: ['UU ITE', 'Legal', 'Ethical Hacking'],
      likes: 312,
      comments: 78,
      isTrending: true,
      isMentorPick: true,
    ),
    CommunityPost(
      id: 'post-3',
      username: 'r3v_ninja',
      avatarInitials: 'RN',
      avatarColor: Color(0xFF8B5CF6),
      timeAgo: '1 day ago',
      title: 'Cracked the Crypto Challenge! Here\'s my write-up',
      body: 'Finally solved crypto-03 in CyberLaw! The challenge used a Vigenère cipher with key length discovery. Used frequency analysis to find the key length (7), then broke each column separately. Let me know if you want the full solution walkthrough!',
      tags: ['CTF', 'Write-up', 'Crypto'],
      likes: 156,
      comments: 34,
    ),
    CommunityPost(
      id: 'post-4',
      username: 'sec_girl_99',
      avatarInitials: 'SG',
      avatarColor: Color(0xFFEC4899),
      timeAgo: '1 day ago',
      title: 'REVIEW: "The Art of Invisibility" by Kevin Mitnick',
      body: 'Just finished this book and it\'s a must-read for anyone serious about privacy. Mitnick explains how our digital footprints are tracked everywhere. Practical advice on encryption, VPNs, and operational security. 10/10 would recommend!',
      tags: ['Book Review', 'Privacy', 'Recommendation'],
      likes: 287,
      comments: 45,
      isMentorPick: true,
    ),
    CommunityPost(
      id: 'post-5',
      username: 'terminal_ghost',
      avatarInitials: 'TG',
      avatarColor: Color(0xFFF59E0B),
      timeAgo: '2 days ago',
      title: 'Setting Up Your First Home Lab',
      body: 'Complete guide to building a safe hacking lab: VirtualBox + Kali Linux + Metasploitable + DVWA. All free, all legal. Perfect for beginners who want to practice without breaking the law. Includes network config tips to isolate your lab from your main network.',
      tags: ['Tutorial', 'Kali Linux', 'Home Lab'],
      likes: 456,
      comments: 92,
      isTrending: true,
    ),
    CommunityPost(
      id: 'post-6',
      username: 'cipher_queen',
      avatarInitials: 'CQ',
      avatarColor: Color(0xFF06B6D4),
      timeAgo: '3 days ago',
      title: 'OWASP Top 10: What Changed in 2024?',
      body: 'The new OWASP Top 10 is here and there are significant changes! Broken Access Control moved to #1 (deservedly so). New categories for SSRF and Software Supply Chain security. Time to update your pentesting checklist!',
      tags: ['OWASP', 'Web Security', 'News'],
      likes: 198,
      comments: 41,
    ),
    CommunityPost(
      id: 'post-7',
      username: 'packet_sniffer',
      avatarInitials: 'PS',
      avatarColor: Color(0xFF10B981),
      timeAgo: '4 days ago',
      title: 'Looking for CTF Team Members',
      body: 'Starting a CTF team for the upcoming HackToday 2024 competition. Looking for: web security specialist, crypto person, and someone strong at forensics. We practice every Saturday. DM me if interested! Beginner-friendly.',
      tags: ['CTF Team', 'Looking For', 'HackToday'],
      likes: 89,
      comments: 23,
    ),
    CommunityPost(
      id: 'post-8',
      username: 'zero_day_zeta',
      avatarInitials: 'ZZ',
      avatarColor: Color(0xFFEF4444),
      timeAgo: '5 days ago',
      title: 'My First CVE: How I Found a Bug in Popular CMS',
      body: 'Never thought I\'d get a CVE but here we are! Found an authenticated RCE in a popular CMS plugin. The key was looking at file upload functionality more carefully. Write-up coming soon. If I can do it, so can you!',
      tags: ['CVE', 'Bug Bounty', 'RCE'],
      likes: 523,
      comments: 112,
      isTrending: true,
      isMentorPick: true,
    ),
  ];

  static List<CommunityPost> get trending =>
      posts.where((p) => p.isTrending).toList();

  static List<CommunityPost> get mentorPicks =>
      posts.where((p) => p.isMentorPick).toList();
}
