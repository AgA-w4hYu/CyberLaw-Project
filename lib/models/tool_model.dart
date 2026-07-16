import 'package:flutter/material.dart';

enum ToolCategory {
  encoding,
  hashing,
  password,
  networking,
  osint,
  utilities,
}

class ToolModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final ToolCategory category;
  final bool isPopular;

  const ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    this.isPopular = false,
  });

  String get categoryLabel {
    switch (category) {
      case ToolCategory.encoding:
        return 'Encoding';
      case ToolCategory.hashing:
        return 'Hashing';
      case ToolCategory.password:
        return 'Password';
      case ToolCategory.networking:
        return 'Networking';
      case ToolCategory.osint:
        return 'OSINT';
      case ToolCategory.utilities:
        return 'Utilities';
    }
  }
}

class MockToolData {
  static const List<ToolModel> tools = [
    ToolModel(
      id: 'base64',
      name: 'Base64',
      description: 'Encode & decode Base64 strings',
      icon: Icons.code,
      color: Color(0xFF3B82F6),
      category: ToolCategory.encoding,
      isPopular: true,
    ),
    ToolModel(
      id: 'binary',
      name: 'Binary Decoder',
      description: 'Convert binary to text and vice versa',
      icon: Icons.looks_3,
      color: Color(0xFF10B981),
      category: ToolCategory.encoding,
      isPopular: true,
    ),
    ToolModel(
      id: 'hex',
      name: 'Hex Converter',
      description: 'Convert hex to text, decimal, and binary',
      icon: Icons.tag,
      color: Color(0xFFF59E0B),
      category: ToolCategory.encoding,
    ),
    ToolModel(
      id: 'url-encoder',
      name: 'URL Encoder',
      description: 'Encode and decode URL parameters',
      icon: Icons.link,
      color: Color(0xFF8B5CF6),
      category: ToolCategory.encoding,
    ),
    ToolModel(
      id: 'jwt',
      name: 'JWT Decoder',
      description: 'Decode and inspect JWT tokens',
      icon: Icons.token,
      color: Color(0xFFEF4444),
      category: ToolCategory.encoding,
    ),
    ToolModel(
      id: 'hash-gen',
      name: 'Hash Generator',
      description: 'MD5, SHA-1, SHA-256, SHA-512',
      icon: Icons.fingerprint,
      color: Color(0xFFEC4899),
      category: ToolCategory.hashing,
      isPopular: true,
    ),
    ToolModel(
      id: 'hash-check',
      name: 'Hash Checker',
      description: 'Compare and verify hash values',
      icon: Icons.compare_arrows,
      color: Color(0xFF8B5CF6),
      category: ToolCategory.hashing,
    ),
    ToolModel(
      id: 'password-strength',
      name: 'Password Strength',
      description: 'Analyze password strength in real-time',
      icon: Icons.lock,
      color: Color(0xFF10B981),
      category: ToolCategory.password,
      isPopular: true,
    ),
    ToolModel(
      id: 'common-password',
      name: 'Common Passwords',
      description: 'Check if password is in common breach lists',
      icon: Icons.warning_amber,
      color: Color(0xFFF59E0B),
      category: ToolCategory.password,
    ),
    ToolModel(
      id: 'ip-calc',
      name: 'IP Calculator',
      description: 'Calculate subnet, network, and broadcast addresses',
      icon: Icons.dns,
      color: Color(0xFF3B82F6),
      category: ToolCategory.networking,
    ),
    ToolModel(
      id: 'port-scan',
      name: 'Port Scanner',
      description: 'Check common open ports on a target',
      icon: Icons.wifi_tethering,
      color: Color(0xFF06B6D4),
      category: ToolCategory.networking,
    ),
    ToolModel(
      id: 'phishing',
      name: 'Phishing Checker',
      description: 'Analyze URLs for phishing indicators',
      icon: Icons.link_off,
      color: Color(0xFFEF4444),
      category: ToolCategory.osint,
      isPopular: true,
    ),
    ToolModel(
      id: 'domain-info',
      name: 'Domain Info',
      description: 'Look up WHOIS and DNS information',
      icon: Icons.language,
      color: Color(0xFF8B5CF6),
      category: ToolCategory.osint,
    ),
    ToolModel(
      id: 'caesar',
      name: 'Caesar Cipher',
      description: 'Encrypt and decrypt Caesar cipher texts',
      icon: Icons.text_fields,
      color: Color(0xFFF59E0B),
      category: ToolCategory.utilities,
    ),
    ToolModel(
      id: 'text-analyzer',
      name: 'Text Analyzer',
      description: 'Analyze text: character count, entropy, patterns',
      icon: Icons.analytics,
      color: Color(0xFFEC4899),
      category: ToolCategory.utilities,
    ),
  ];

  static List<ToolModel> get popular =>
      tools.where((t) => t.isPopular).toList();

  static List<ToolModel> getByCategory(ToolCategory category) =>
      tools.where((t) => t.category == category).toList();

  static ToolModel? getById(String id) {
    try {
      return tools.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
