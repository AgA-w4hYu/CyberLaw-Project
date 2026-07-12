import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      context.go(AppConstants.routeHome);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Registrasi gagal'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('DAFTAR AKUN'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Bergabunglah dengan komunitas\nwhite-hat terpercaya',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
                  ).animate().fadeIn(),
                  const SizedBox(height: 32),

                  CyberTextField(
                    label: 'Nama Lengkap',
                    controller: _nameCtrl,
                    prefixIcon: const Icon(Icons.person_outline, color: AppTheme.textSecondary, size: 20),
                    validator: (v) => (v?.isEmpty ?? true) ? 'Nama wajib diisi' : null,
                  ).animate().slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut),
                  const SizedBox(height: 16),

                  CyberTextField(
                    label: 'Email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.alternate_email, color: AppTheme.textSecondary, size: 20),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email wajib diisi';
                      if (!v.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ).animate().slideY(begin: 0.3, delay: 100.ms, duration: 400.ms, curve: Curves.easeOut),
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
                      if (v.length < 8) return 'Password minimal 8 karakter';
                      return null;
                    },
                  ).animate().slideY(begin: 0.3, delay: 200.ms, duration: 400.ms, curve: Curves.easeOut),
                  const SizedBox(height: 16),

                  CyberTextField(
                    label: 'Konfirmasi Password',
                    controller: _confirmCtrl,
                    obscureText: !_showPass,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.textSecondary, size: 20),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                      if (v != _passCtrl.text) return 'Password tidak cocok';
                      return null;
                    },
                  ).animate().slideY(begin: 0.3, delay: 300.ms, duration: 400.ms, curve: Curves.easeOut),
                  const SizedBox(height: 32),

                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => NeonButton(
                      label: 'DAFTAR SEKARANG',
                      width: double.infinity,
                      isLoading: auth.status == AuthStatus.loading,
                      onPressed: _register,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun? ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(color: AppTheme.primary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
