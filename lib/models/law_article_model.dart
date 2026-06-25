class LawArticleModel {
  final String id;
  final String title;
  final String category;
  final String summary;
  final String content;
  final String icon;
  final List<String> tags;

  const LawArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    required this.icon,
    required this.tags,
  });
}

class LawArticleData {
  static const List<LawArticleModel> articles = [
    LawArticleModel(
      id: 'uu-ite-1',
      title: 'UU ITE No. 11 Tahun 2008',
      category: 'Hukum Siber',
      summary: 'Undang-Undang Informasi dan Transaksi Elektronik — dasar hukum kejahatan siber di Indonesia.',
      icon: '⚖️',
      tags: ['UU ITE', 'Indonesia', 'Hukum Siber'],
      content: '''
## Undang-Undang ITE No. 11 Tahun 2008

Undang-Undang Nomor 11 Tahun 2008 tentang Informasi dan Transaksi Elektronik (UU ITE) adalah regulasi utama yang mengatur aktivitas digital di Indonesia.

### Pokok-Pokok UU ITE

**Pasal 27** — Melarang distribusi konten ilegal, perjudian online, penghinaan, dan pemerasan melalui media elektronik.

**Pasal 28** — Melarang penyebaran berita bohong (hoaks) yang merugikan konsumen dan konten bermuatan kebencian (SARA).

**Pasal 30** — Melarang akses ilegal ke sistem komputer milik orang lain (hacking tanpa izin).

**Pasal 32** — Melarang intersepsi, pengubahan, dan perusakan data elektronik milik orang lain.

**Pasal 33** — Melarang tindakan yang mengakibatkan gangguan sistem elektronik (DDoS, malware).

### Sanksi

Pelanggaran UU ITE dapat dikenai pidana penjara hingga **12 tahun** dan denda hingga **Rp 12 miliar**.

### Revisi 2024

Revisi terbaru UU ITE (UU No. 1 Tahun 2024) mempertegas perlindungan privasi data dan menambah aturan terkait AI serta platform digital.

### Relevansi untuk Ethical Hackers

Ethical hacker **wajib memiliki izin tertulis** sebelum melakukan pengujian penetrasi. Tanpa izin, aktivitas pengujian keamanan dapat dijerat Pasal 30 dan Pasal 32 UU ITE.
''',
    ),
    LawArticleModel(
      id: 'privacy-1',
      title: 'Hak Privasi Digital & UU PDP',
      category: 'Privasi Data',
      summary: 'UU Perlindungan Data Pribadi (UU PDP) dan hak-hak pengguna atas data mereka.',
      icon: '🔒',
      tags: ['Privasi', 'UU PDP', 'GDPR', 'Data'],
      content: '''
## Hak Privasi Digital & UU PDP

Undang-Undang Perlindungan Data Pribadi (UU PDP) No. 27 Tahun 2022 adalah regulasi komprehensif pertama Indonesia terkait perlindungan data pribadi.

### Hak-Hak Subjek Data

1. **Hak atas informasi** — Mengetahui bagaimana data pribadi digunakan
2. **Hak akses** — Mendapatkan salinan data pribadi yang dimiliki perusahaan
3. **Hak untuk dikoreksi** — Meminta perbaikan data yang tidak akurat
4. **Hak untuk dihapus** — Meminta penghapusan data (right to be forgotten)
5. **Hak portabilitas** — Memindahkan data ke layanan lain
6. **Hak menolak pemrosesan** — Menolak data digunakan untuk profiling

### Kewajiban Pengendali Data

- Memiliki **dasar hukum yang sah** untuk memproses data
- Menerapkan **prinsip minimasi data** (hanya kumpulkan yang perlu)
- Melaporkan **kebocoran data** dalam 14 hari
- Menunjuk **Data Protection Officer (DPO)** untuk organisasi besar

### Sanksi UU PDP

Pelanggaran dapat dikenai denda administratif hingga **2% dari pendapatan tahunan** dan pidana penjara hingga **6 tahun**.

### Perbandingan dengan GDPR

UU PDP terinspirasi dari GDPR Eropa namun disesuaikan dengan konteks Indonesia, termasuk penanganan data cross-border dan sanksi yang disesuaikan.
''',
    ),
    LawArticleModel(
      id: 'cybercrime-cases',
      title: 'Studi Kasus: Kejahatan Siber di Indonesia',
      category: 'Kasus Nyata',
      summary: 'Analisis kasus-kasus kejahatan siber besar yang pernah terjadi di Indonesia.',
      icon: '🔍',
      tags: ['Kasus', 'Forensik', 'Hacking', 'Phishing'],
      content: '''
## Studi Kasus Kejahatan Siber Indonesia

### Kasus 1: Kebocoran Data BPJS (2021)

**Kronologi:** 279 juta data peserta BPJS Kesehatan bocor dan dijual di forum hacker dark web seharga 6.000 dolar AS.

**Dampak:** Data mencakup nama, NIK, nomor telepon, dan data medis jutaan warga Indonesia.

**Pelajaran:**
- Pentingnya enkripsi database at-rest
- Audit keamanan berkala wajib dilakukan
- Respons insiden harus cepat dan transparan

---

### Kasus 2: Serangan DDoS Platform E-commerce (2020)

**Kronologi:** Sebuah platform e-commerce besar Indonesia diserang DDoS selama 4 jam pada momen Harbolnas, melumpuhkan layanan dan menyebabkan kerugian miliaran rupiah.

**Pelajaran:**
- Implementasi CDN dan anti-DDoS wajib ada
- Rate limiting dan WAF harus dikonfigurasi
- Business Continuity Plan (BCP) harus dipersiapkan

---

### Kasus 3: Phishing Perbankan Mobile (2022)

**Kronologi:** Ribuan nasabah bank tertipu aplikasi palsu yang meniru tampilan aplikasi mobile banking resmi, mengakibatkan kerugian ratusan juta rupiah.

**Pelajaran:**
- Hanya unduh aplikasi dari Play Store / App Store resmi
- Verifikasi developer aplikasi sebelum install
- Aktifkan notifikasi transaksi real-time

---

### Kasus 4: Ransomware BSI (2023)

**Kronologi:** Bank Syariah Indonesia (BSI) mengalami serangan ransomware LockBit yang melumpuhkan layanan ATM dan mobile banking selama beberapa hari.

**Dampak:** Data 15 juta nasabah diklaim bocor, kerugian operasional sangat besar.

**Pelajaran:**
- Backup data offline yang terisolasi sangat penting
- Patch manajemen harus up-to-date
- Zero-trust architecture harus diimplementasikan
''',
    ),
    LawArticleModel(
      id: 'ethical-hacking',
      title: 'Aturan & Kode Etik Ethical Hacking',
      category: 'Etika Keamanan',
      summary: 'Prinsip, kode etik, dan batasan legal yang wajib diketahui setiap security researcher.',
      icon: '🛡️',
      tags: ['Ethical Hacking', 'Bug Bounty', 'CEH', 'Pentest'],
      content: '''
## Kode Etik Ethical Hacker

### Prinsip Utama

**1. Always Get Permission**
Tidak ada pengujian keamanan yang dilakukan tanpa izin tertulis dari pemilik sistem. Bahkan pada sistem milik sendiri di jaringan bersama, izin tertulis tetap diperlukan.

**2. Stay Within Scope**
Hanya uji sistem yang ada dalam ruang lingkup (scope) perjanjian. Jangan menyentuh sistem atau data di luar scope meskipun terlihat rentan.

**3. Do No Harm**
Hindari tindakan yang merusak, mengubah, atau menghapus data. Gunakan teknik non-destruktif jika memungkinkan.

**4. Protect Privacy**
Data sensitif yang ditemukan selama pengujian harus dilindungi dan tidak disebarluaskan.

**5. Report Responsibly**
Temuan kerentanan dilaporkan ke pihak yang tepat sebelum dipublikasikan (Responsible Disclosure / Coordinated Disclosure).

---

### Program Bug Bounty

Bug bounty adalah program legal di mana perusahaan mengundang peneliti keamanan untuk menemukan celah pada sistem mereka dengan imbalan reward.

**Platform Bug Bounty Terkemuka:**
- HackerOne
- Bugcrowd
- Synack
- YesWeHack (populer di Asia)

**Tips Bug Bounty:**
- Baca program policy dengan teliti sebelum memulai
- Dokumentasikan setiap langkah pengujian
- Submite laporan yang jelas dengan PoC (Proof of Concept)

---

### Sertifikasi Keamanan Siber

| Sertifikasi | Level | Fokus |
|---|---|---|
| CompTIA Security+ | Pemula | Dasar keamanan jaringan |
| CEH | Menengah | Ethical hacking metodologi |
| OSCP | Lanjut | Penetration testing praktis |
| CISSP | Expert | Manajemen keamanan informasi |

---

### Disclaimer Penggunaan Tools

Semua tool keamanan di aplikasi ini dirancang untuk keperluan **edukatif dan legal** semata. Penggunaan untuk menyerang sistem tanpa izin adalah tindakan ilegal yang dapat dijerat Pasal 30-33 UU ITE.
''',
    ),
  ];
}
