import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (success) {
      context.go(AppConstants.routeHome);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF0D2137), AppTheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo / Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                          ),
                          boxShadow: AppTheme.neonGlow(AppTheme.primary),
                        ),
                        child: const Icon(Icons.shield_outlined, color: AppTheme.background, size: 44),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 20),
                      Text(
                        'CYBERLAW',
                        style: GoogleFonts.orbitron(
                          color: AppTheme.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      Text(
                        'GUARDIAN',
                        style: GoogleFonts.orbitron(
                          color: AppTheme.secondary,
                          fontSize: 16,
                          letterSpacing: 6,
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 8),
                      Text(
                        'Cybersecurity Learning Platform',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CyberTextField(
                        label: 'Email',
                        hint: 'demo@cyberlaw.id',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.alternate_email, color: AppTheme.textSecondary, size: 20),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                          if (!v.contains('@')) return 'Format email tidak valid';
                          return null;
                        },
                      ).animate().slideY(begin: 0.3, delay: 500.ms, duration: 400.ms, curve: Curves.easeOut),
                      const SizedBox(height: 16),
                      CyberTextField(
                        label: 'Password',
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.textSecondary, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _showPass = !_showPass),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password wajib diisi';
                          if (v.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ).animate().slideY(begin: 0.3, delay: 600.ms, duration: 400.ms, curve: Curves.easeOut),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Lupa Password?', style: TextStyle(color: AppTheme.primary, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Consumer<AuthProvider>(
                        builder: (_, auth, __) => NeonButton(
                          label: 'MASUK',
                          width: double.infinity,
                          isLoading: auth.status == AuthStatus.loading,
                          onPressed: _login,
                        ),
                      ).animate().fadeIn(delay: 700.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppTheme.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('atau', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ),
                    const Expanded(child: Divider(color: AppTheme.border)),
                  ],
                ),
                const SizedBox(height: 24),

                // Demo login hint
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo: gunakan email apapun (format valid) + password min. 6 karakter',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => context.push(AppConstants.routeRegister),
                        child: Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: AppTheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 900.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
