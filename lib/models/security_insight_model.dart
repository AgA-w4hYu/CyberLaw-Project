import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class SecurityInsightModel {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String urgencyLabel;
  final IconData icon;
  final Color color;
  final List<String> firstResponseSteps;
  final List<String> preventionTips;
  final String legalGuidance;
  final List<String> tags;

  const SecurityInsightModel({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.urgencyLabel,
    required this.icon,
    required this.color,
    required this.firstResponseSteps,
    required this.preventionTips,
    required this.legalGuidance,
    required this.tags,
  });
}

class SecurityInsightData {
  static const List<String> quickChecklist = [
    'Amankan email utama dan nomor telepon pemulihan sebelum pelaku mengubah akses inti.',
    'Ganti password akun penting lalu paksa logout semua sesi yang masih aktif.',
    'Aktifkan 2FA atau verifikasi dua langkah pada akun yang belum dilindungi.',
    'Simpan bukti seperti screenshot, email notifikasi, URL, waktu kejadian, dan nomor yang terlibat.',
    'Hubungi platform, operator, bank, atau e-wallet hanya lewat kanal resmi.',
  ];

  static const List<SecurityInsightModel> insights = [
    SecurityInsightModel(
      id: 'social-account-takeover',
      title: 'Akun Media Sosial Diretas',
      category: 'Akun',
      summary:
          'Saat password, email pemulihan, atau nomor verifikasi berubah, fokus utama adalah merebut kembali akses inti dan memutus sesi pelaku.',
      urgencyLabel: 'Kritis',
      icon: Icons.lock_person,
      color: AppTheme.accent,
      firstResponseSteps: [
        'Ganti password email utama terlebih dahulu karena email biasanya jadi pintu reset ke semua akun lain.',
        'Gunakan fitur logout all sessions atau keluar dari semua perangkat pada Instagram, TikTok, Facebook, dan akun lain yang terdampak.',
        'Periksa email pemulihan, nomor telepon, dan perangkat terpercaya agar tidak masih terdaftar milik pelaku.',
        'Aktifkan 2FA setelah akses kembali aman, lalu simpan backup code di tempat terpisah.',
        'Dokumentasikan perubahan username, email notifikasi, DM spam, atau posting aneh yang muncul selama takeover.',
      ],
      preventionTips: [
        'Pakai password unik untuk setiap akun, terutama email dan media sosial.',
        'Gunakan aplikasi authenticator, jangan hanya mengandalkan OTP SMS.',
        'Hindari login di perangkat pinjaman dan segera cabut akses aplikasi pihak ketiga yang tidak diperlukan.',
      ],
      legalGuidance:
          'Jangan menyerang balik akun pelaku. Simpan bukti dan gunakan kanal recovery resmi platform sebelum eskalasi ke pihak berwenang atau pendamping hukum.',
      tags: ['Instagram', 'TikTok', 'Facebook', '2FA'],
    ),
    SecurityInsightModel(
      id: 'lost-phone',
      title: 'HP Hilang atau Dicuri',
      category: 'Perangkat',
      summary:
          'Saat ponsel hilang, yang terancam bukan hanya perangkatnya, tetapi juga SIM card, email, mobile banking, chat, dan OTP.',
      urgencyLabel: 'Kritis',
      icon: Icons.phone_android,
      color: AppTheme.warning,
      firstResponseSteps: [
        'Hubungi operator untuk memblokir SIM atau memindahkan nomor ke SIM baru agar OTP tidak diambil orang lain.',
        'Gunakan Find My Device atau Find My iPhone untuk mengunci perangkat, menampilkan pesan kontak, atau menghapus data jarak jauh bila perlu.',
        'Logout akun Google, Apple ID, email, dan media sosial dari perangkat yang hilang.',
        'Blokir atau amankan mobile banking, e-wallet, dan aplikasi yang menyimpan data finansial.',
        'Catat waktu hilang, lokasi terakhir, IMEI, dan daftar akun penting yang masih login di perangkat tersebut.',
      ],
      preventionTips: [
        'Aktifkan kunci layar yang kuat, biometrik, dan auto-lock yang singkat.',
        'Pastikan fitur pelacakan perangkat aktif sejak awal, bukan setelah perangkat hilang.',
        'Pisahkan PIN perangkat, PIN SIM, dan password email agar satu kebocoran tidak membuka semua akses.',
      ],
      legalGuidance:
          'Jika ada dugaan pencurian atau penyalahgunaan identitas, simpan IMEI, kronologi, dan bukti lokasi terakhir untuk laporan ke operator atau pihak berwenang.',
      tags: ['IMEI', 'SIM Card', 'Banking', 'Remote Wipe'],
    ),
    SecurityInsightModel(
      id: 'phishing-clicked',
      title: 'Sudah Klik Link Phishing',
      category: 'Phishing',
      summary:
          'Kalau kamu sudah klik tautan, login, atau mengisi data, anggap kredensial sudah berisiko dan lakukan containment secepat mungkin.',
      urgencyLabel: 'Tinggi',
      icon: Icons.link_off,
      color: AppTheme.primary,
      firstResponseSteps: [
        'Segera ganti password akun yang tadi dimasuki dan akun lain yang memakai password serupa.',
        'Periksa apakah ada aplikasi atau APK yang ikut terpasang, lalu hapus bila mencurigakan.',
        'Cek aktivitas login, transaksi, email forward otomatis, dan perangkat yang masih aktif.',
        'Scan perangkat dengan solusi keamanan tepercaya jika sempat mengunduh file atau aplikasi.',
        'Beritahu kontak terdekat jika akunmu sempat mengirim spam, link palsu, atau permintaan uang.',
      ],
      preventionTips: [
        'Biasakan cek domain secara penuh, bukan hanya nama brand di tampilan pesan.',
        'Jangan install APK dari tautan chat atau browser untuk layanan yang punya store resmi.',
        'Gunakan password manager agar login palsu lebih mudah dikenali.',
      ],
      legalGuidance:
          'Jika data finansial, OTP, PIN, atau kartu sempat dimasukkan, prioritaskan blokir layanan resmi terlebih dahulu sebelum langkah lain.',
      tags: ['URL', 'OTP', 'APK', 'Spam'],
    ),
    SecurityInsightModel(
      id: 'whatsapp-takeover',
      title: 'Nomor WhatsApp Diambil Alih',
      category: 'Akun',
      summary:
          'Kasus ini sering dimulai dari kode OTP, social engineering, atau SIM swap. Waktu respons sangat menentukan.',
      urgencyLabel: 'Tinggi',
      icon: Icons.chat_bubble,
      color: AppTheme.secondary,
      firstResponseSteps: [
        'Masuk ulang ke WhatsApp dengan nomor yang sama agar sesi pelaku tertendang dari akun.',
        'Hubungi operator untuk memastikan SIM aman dan tidak terjadi pemindahan nomor tanpa izin.',
        'Aktifkan verifikasi dua langkah WhatsApp dan tambahkan email pemulihan.',
        'Umumkan ke kontak dekat bahwa akunmu sempat diambil alih agar mereka tidak tertipu pesan pinjaman atau OTP.',
        'Periksa perangkat tertaut, foto profil, deskripsi, dan pesan otomatis yang berubah.',
      ],
      preventionTips: [
        'Jangan pernah membagikan OTP atau kode verifikasi ke siapa pun.',
        'Aktifkan PIN SIM untuk menambah lapisan proteksi pada nomor utama.',
        'Pisahkan nomor publik dan nomor yang dipakai untuk akun penting bila memungkinkan.',
      ],
      legalGuidance:
          'Simpan bukti chat, nomor asing, tangkapan layar permintaan OTP, dan waktu kejadian untuk memperkuat laporan bila penipuan berlanjut.',
      tags: ['WhatsApp', 'OTP', 'SIM Swap', 'Kontak'],
    ),
    SecurityInsightModel(
      id: 'data-leak',
      title: 'Data Pribadi Bocor',
      category: 'Privasi',
      summary:
          'Kebocoran data sering berdampak berantai: reset akun, impersonasi, spam, doxxing, dan social engineering lanjutan.',
      urgencyLabel: 'Sedang',
      icon: Icons.privacy_tip,
      color: const Color(0xFF00B4D8),
      firstResponseSteps: [
        'Ganti password untuk layanan yang memakai kombinasi email dan password yang sama.',
        'Aktifkan notifikasi transaksi bank, e-wallet, dan marketplace untuk mendeteksi penyalahgunaan cepat.',
        'Waspadai telepon atau chat yang menyebut data pribadi secara meyakinkan karena itu bisa dipakai untuk rekayasa sosial.',
        'Periksa izin aplikasi dan akun yang menampilkan terlalu banyak informasi publik.',
        'Simpan email, pemberitahuan, atau bukti sumber kebocoran untuk dokumentasi insiden.',
      ],
      preventionTips: [
        'Gunakan password manager supaya setiap akun punya password yang berbeda.',
        'Batasi data sensitif di bio, status, dan unggahan publik.',
        'Pisahkan email utama, email belanja, dan email promosi untuk mengurangi efek domino.',
      ],
      legalGuidance:
          'Kalau kebocoran berkembang menjadi ancaman, doxxing, atau penipuan, jangan hapus bukti. Dokumentasikan dan eskalasi melalui kanal resmi yang relevan.',
      tags: ['Privasi', 'Doxxing', 'Password', 'Identitas'],
    ),
  ];
}
