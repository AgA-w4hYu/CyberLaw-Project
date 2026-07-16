import 'package:flutter/material.dart';

enum PathDifficulty { beginner, intermediate, advanced }

class LearningPath {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final PathDifficulty difficulty;
  final int totalLessons;
  final int completedLessons;
  final int estimatedHours;
  final List<Lesson> lessons;
  final List<String> skills;
  final bool hasBadge;

  const LearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.totalLessons,
    this.completedLessons = 0,
    required this.estimatedHours,
    required this.lessons,
    required this.skills,
    this.hasBadge = false,
  });

  double get progress => totalLessons > 0 ? completedLessons / totalLessons : 0.0;

  String get difficultyLabel {
    switch (difficulty) {
      case PathDifficulty.beginner:
        return 'Beginner';
      case PathDifficulty.intermediate:
        return 'Intermediate';
      case PathDifficulty.advanced:
        return 'Advanced';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case PathDifficulty.beginner:
        return const Color(0xFF10B981);
      case PathDifficulty.intermediate:
        return const Color(0xFFF59E0B);
      case PathDifficulty.advanced:
        return const Color(0xFFEF4444);
    }
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final bool isCompleted;
  final bool isLocked;
  final LessonType type;
  final List<String> content;
  final List<QuizQuestion>? quiz;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.durationMinutes = 10,
    this.isCompleted = false,
    this.isLocked = false,
    this.type = LessonType.reading,
    this.content = const [],
    this.quiz,
  });
}

enum LessonType { reading, video, quiz, interactive }

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// ── Mock Data ──

class MockLearningData {
  static final List<LearningPath> paths = [
    LearningPath(
      id: 'network',
      title: 'Network Security',
      description: 'Learn how networks work and how to secure them from attacks.',
      icon: Icons.language,
      color: const Color(0xFF3B82F6),
      difficulty: PathDifficulty.beginner,
      totalLessons: 6,
      completedLessons: 3,
      estimatedHours: 4,
      skills: ['TCP/IP', 'Firewalls', 'IDS/IPS', 'VPN', 'Network Scanning'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'net-1',
          title: 'Introduction to Networks',
          description: 'Understand the basics of computer networks and protocols.',
          durationMinutes: 12,
          isCompleted: true,
          content: [
            'A computer network is a set of computers sharing resources located on or provided by network nodes.',
            'Networks use protocols (like TCP/IP) to communicate and transfer data between devices.',
            'Key concepts: IP addresses, ports, DNS, routing, and switching.',
          ],
          quiz: [
            QuizQuestion(
              question: 'What does IP stand for?',
              options: ['Internet Protocol', 'Internal Process', 'Information Pack', 'Integrated Platform'],
              correctIndex: 0,
              explanation: 'IP stands for Internet Protocol, which is the principal communications protocol.',
            ),
          ],
        ),
        Lesson(
          id: 'net-2',
          title: 'TCP/IP Protocol Stack',
          description: 'Deep dive into the TCP/IP model and how data flows.',
          durationMinutes: 15,
          isCompleted: true,
          content: [
            'The TCP/IP model has 4 layers: Application, Transport, Internet, and Network Access.',
            'TCP ensures reliable data delivery with error checking and flow control.',
            'IP handles addressing and routing of packets across networks.',
          ],
        ),
        Lesson(
          id: 'net-3',
          title: 'Common Network Attacks',
          description: 'Learn about MITM, DoS, ARP spoofing and how to defend.',
          durationMinutes: 18,
          isCompleted: true,
          content: [
            'Man-in-the-Middle (MITM): attacker intercepts communication between two parties.',
            'Denial of Service (DoS): overwhelming a system to make it unavailable.',
            'ARP Spoofing: sending fake ARP messages to associate attacker\'s MAC with IP.',
          ],
        ),
        Lesson(
          id: 'net-4',
          title: 'Firewall Fundamentals',
          description: 'How firewalls work and how to configure basic rules.',
          durationMinutes: 14,
          isCompleted: false,
        ),
        Lesson(
          id: 'net-5',
          title: 'Network Scanning with Nmap',
          description: 'Practical introduction to network reconnaissance.',
          durationMinutes: 20,
          isCompleted: false,
        ),
        Lesson(
          id: 'net-6',
          title: 'Network Security Quiz',
          description: 'Test your knowledge of network security concepts.',
          durationMinutes: 10,
          isCompleted: false,
          type: LessonType.quiz,
        ),
      ],
    ),
    LearningPath(
      id: 'crypto',
      title: 'Cryptography',
      description: 'Master encryption, hashing, and cryptographic protocols.',
      icon: Icons.vpn_key,
      color: const Color(0xFF8B5CF6),
      difficulty: PathDifficulty.intermediate,
      totalLessons: 5,
      completedLessons: 1,
      estimatedHours: 5,
      skills: ['Symmetric', 'Asymmetric', 'Hashing', 'PKI', 'SSL/TLS'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'crypto-1',
          title: 'What is Cryptography?',
          description: 'History and fundamentals of cryptography.',
          durationMinutes: 10,
          isCompleted: true,
          content: [
            'Cryptography is the practice of secure communication in the presence of adversaries.',
            'It dates back to ancient Egypt with hieroglyph ciphers.',
            'Modern cryptography uses complex mathematical algorithms.',
          ],
        ),
        Lesson(
          id: 'crypto-2',
          title: 'Symmetric Encryption',
          description: 'AES, DES, and how symmetric keys work.',
          durationMinutes: 15,
          isCompleted: false,
        ),
        Lesson(
          id: 'crypto-3',
          title: 'Asymmetric Encryption',
          description: 'RSA, ECC, and public-key infrastructure.',
          durationMinutes: 18,
          isCompleted: false,
        ),
        Lesson(
          id: 'crypto-4',
          title: 'Hashing Algorithms',
          description: 'MD5, SHA family, and their applications.',
          durationMinutes: 12,
          isCompleted: false,
        ),
        Lesson(
          id: 'crypto-5',
          title: 'Cryptography Quiz',
          description: 'Test your cryptographic knowledge.',
          durationMinutes: 10,
          isCompleted: false,
          type: LessonType.quiz,
        ),
      ],
    ),
    LearningPath(
      id: 'websec',
      title: 'Web Security',
      description: 'Understand OWASP Top 10 and how to secure web applications.',
      icon: Icons.web,
      color: const Color(0xFFF59E0B),
      difficulty: PathDifficulty.beginner,
      totalLessons: 6,
      completedLessons: 0,
      estimatedHours: 6,
      skills: ['XSS', 'SQLi', 'CSRF', 'Authentication', 'OWASP'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'web-1',
          title: 'How the Web Works',
          description: 'HTTP, HTTPS, cookies, sessions, and the browser model.',
          durationMinutes: 12,
          isCompleted: false,
        ),
        Lesson(
          id: 'web-2',
          title: 'Cross-Site Scripting (XSS)',
          description: 'Learn about stored, reflected, and DOM-based XSS.',
          durationMinutes: 18,
          isCompleted: false,
        ),
        Lesson(
          id: 'web-3',
          title: 'SQL Injection',
          description: 'How SQLi works and how to prevent it.',
          durationMinutes: 20,
          isCompleted: false,
        ),
        Lesson(
          id: 'web-4',
          title: 'CSRF & Session Hijacking',
          description: 'Cross-site request forgery and how to defend.',
          durationMinutes: 15,
          isCompleted: false,
        ),
        Lesson(
          id: 'web-5',
          title: 'Authentication & Authorization',
          description: 'JWT, OAuth, session management best practices.',
          durationMinutes: 18,
          isCompleted: false,
        ),
        Lesson(
          id: 'web-6',
          title: 'Web Security Quiz',
          description: 'Test your web security knowledge.',
          durationMinutes: 10,
          isCompleted: false,
          type: LessonType.quiz,
        ),
      ],
    ),
    LearningPath(
      id: 'forensics',
      title: 'Digital Forensics',
      description: 'Learn how to investigate and analyze digital evidence.',
      icon: Icons.manage_search,
      color: const Color(0xFF10B981),
      difficulty: PathDifficulty.intermediate,
      totalLessons: 4,
      completedLessons: 0,
      estimatedHours: 4,
      skills: ['File Analysis', 'Memory Forensics', 'Network Forensics', 'Steganography'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'for-1',
          title: 'Forensics Fundamentals',
          description: 'Chain of custody, evidence types, and tools.',
          durationMinutes: 12,
          isCompleted: false,
        ),
        Lesson(
          id: 'for-2',
          title: 'File Carving & Recovery',
          description: 'Recover deleted files and analyze file signatures.',
          durationMinutes: 18,
          isCompleted: false,
        ),
        Lesson(
          id: 'for-3',
          title: 'Memory Analysis',
          description: 'Analyze RAM dumps for artifacts and malware.',
          durationMinutes: 20,
          isCompleted: false,
        ),
        Lesson(
          id: 'for-4',
          title: 'Steganography',
          description: 'Hide and find hidden data in images and audio.',
          durationMinutes: 15,
          isCompleted: false,
        ),
      ],
    ),
    LearningPath(
      id: 'reversing',
      title: 'Reverse Engineering',
      description: 'Analyze binaries, understand assembly, and crack software.',
      icon: Icons.memory,
      color: const Color(0xFFEF4444),
      difficulty: PathDifficulty.advanced,
      totalLessons: 4,
      completedLessons: 0,
      estimatedHours: 6,
      skills: ['Assembly', 'Debugging', 'Disassembly', 'Patching'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'rev-1',
          title: 'Assembly Basics',
          description: 'Learn x86/x64 assembly language fundamentals.',
          durationMinutes: 20,
          isCompleted: false,
        ),
        Lesson(
          id: 'rev-2',
          title: 'Disassembly Tools',
          description: 'Using Ghidra, IDA, and radare2.',
          durationMinutes: 25,
          isCompleted: false,
        ),
        Lesson(
          id: 'rev-3',
          title: 'Debugging Techniques',
          description: 'Dynamic analysis with GDB and x64dbg.',
          durationMinutes: 22,
          isCompleted: false,
        ),
        Lesson(
          id: 'rev-4',
          title: 'CrackMe Challenge',
          description: 'Apply your skills to solve a real crackme.',
          durationMinutes: 30,
          isCompleted: false,
        ),
      ],
    ),
    LearningPath(
      id: 'linux',
      title: 'Linux Fundamentals',
      description: 'Master the command line, permissions, and security tools.',
      icon: Icons.terminal,
      color: const Color(0xFF3B82F6),
      difficulty: PathDifficulty.beginner,
      totalLessons: 5,
      completedLessons: 0,
      estimatedHours: 4,
      skills: ['CLI', 'Permissions', 'Processes', 'Networking', 'Shell Scripting'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'lin-1',
          title: 'Getting Started with Linux',
          description: 'Installation, desktop environment, and basic commands.',
          durationMinutes: 10,
          isCompleted: false,
        ),
        Lesson(
          id: 'lin-2',
          title: 'File System & Permissions',
          description: 'Navigate the file system and understand chmod, chown.',
          durationMinutes: 14,
          isCompleted: false,
        ),
        Lesson(
          id: 'lin-3',
          title: 'Process Management',
          description: 'ps, top, kill, and understanding Linux processes.',
          durationMinutes: 12,
          isCompleted: false,
        ),
        Lesson(
          id: 'lin-4',
          title: 'Networking Commands',
          description: 'netstat, ss, nmap, curl, and network config.',
          durationMinutes: 16,
          isCompleted: false,
        ),
        Lesson(
          id: 'lin-5',
          title: 'Shell Scripting Basics',
          description: 'Write your first bash scripts for automation.',
          durationMinutes: 18,
          isCompleted: false,
        ),
      ],
    ),
    LearningPath(
      id: 'cyberlaw',
      title: 'Cyber Law',
      description: 'Understand the legal framework for cybersecurity in Indonesia.',
      icon: Icons.gavel,
      color: const Color(0xFF8B5CF6),
      difficulty: PathDifficulty.beginner,
      totalLessons: 4,
      completedLessons: 0,
      estimatedHours: 3,
      skills: ['UU ITE', 'UU PDP', 'Ethical Hacking', 'Digital Evidence'],
      hasBadge: false,
      lessons: [
        Lesson(
          id: 'law-1',
          title: 'Introduction to Cyber Law',
          description: 'What is cyber law and why it matters in Indonesia.',
          durationMinutes: 10,
          isCompleted: false,
        ),
        Lesson(
          id: 'law-2',
          title: 'UU ITE (Informasi & Transaksi Elektronik)',
          description: 'Pasal 27-37: Understanding the legal boundaries.',
          durationMinutes: 15,
          isCompleted: false,
        ),
        Lesson(
          id: 'law-3',
          title: 'UU PDP (Perlindungan Data Pribadi)',
          description: 'Your rights and obligations regarding personal data.',
          durationMinutes: 14,
          isCompleted: false,
        ),
        Lesson(
          id: 'law-4',
          title: 'Ethical Hacking & The Law',
          description: 'Where is the line between ethical and illegal hacking?',
          durationMinutes: 12,
          isCompleted: false,
        ),
      ],
    ),
  ];
}
