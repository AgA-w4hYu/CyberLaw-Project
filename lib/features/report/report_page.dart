import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/login_gate.dart';

/// Full 8-step Cyber Incident Report flow.
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _step = 0;
  bool _submitted = false;

  // Step 1: Incident type
  String? _incidentType;

  // Step 2: Description
  final _descCtrl = TextEditingController();

  // Step 3: Date & Time
  DateTime _incidentDate = DateTime.now();
  TimeOfDay _incidentTime = TimeOfDay.now();

  // Step 4: Platform
  String? _platform;

  // Step 5: Evidence paths
  final List<String> _evidencePaths = [];

  // Step 6: Suspect info
  final _suspectPhoneCtrl = TextEditingController();
  final _suspectEmailCtrl = TextEditingController();
  final _suspectWebsiteCtrl = TextEditingController();
  final _suspectUsernameCtrl = TextEditingController();

  // Step 7: Review
  // Step 8: Submit

  // Result
  String? _reportId;
  String? _riskLevel;

  final _incidentTypes = [
    'Phishing', 'Online Scam', 'Malware', 'Ransomware',
    'Account Hacking', 'Credential Theft', 'Identity Theft',
    'Website Defacement', 'DDoS', 'Social Engineering',
    'Fake Website', 'Fake Marketplace', 'Cyberbullying',
    'Investment Scam', 'SIM Swap', 'QR Scam',
    'Email Compromise', 'Financial Fraud', 'Data Leak',
    'Other',
  ];

  final _platforms = [
    'WhatsApp', 'Telegram', 'Instagram', 'Facebook',
    'Discord', 'Email', 'Website', 'Marketplace',
    'Bank', 'SMS', 'Phone', 'Other',
  ];

  @override
  void dispose() {
    _descCtrl.dispose();
    _suspectPhoneCtrl.dispose();
    _suspectEmailCtrl.dispose();
    _suspectWebsiteCtrl.dispose();
    _suspectUsernameCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 0 && _incidentType == null) {
      _showError('Please select an incident type');
      return;
    }
    if (_step == 1 && _descCtrl.text.trim().isEmpty) {
      _showError('Please describe the incident');
      return;
    }
    if (_step < 7) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error));
  }

  String _generateRiskLevel() {
    final desc = _descCtrl.text.toLowerCase();
    if (desc.contains('ransomware') || desc.contains('bank') || desc.contains('money') || desc.contains('identity')) return 'Critical';
    if (desc.contains('hack') || desc.contains('malware') || desc.contains('phish') || desc.contains('data')) return 'High';
    if (desc.contains('scam') || desc.contains('fraud') || desc.contains('spam')) return 'Medium';
    return 'Low';
  }

  List<String> _generateActions() {
    final risk = _generateRiskLevel();
    final actions = <String>[];
    actions.add('Change all passwords immediately');
    actions.add('Enable two-factor authentication');
    actions.add('Contact your bank if financial info was compromised');
    if (risk == 'Critical') {
      actions.add('Contact local authorities immediately');
      actions.add('Disconnect affected devices from the internet');
      actions.add('Run a full antivirus scan');
    }
    actions.add('Monitor your accounts for suspicious activity');
    actions.add('Save all evidence securely');
    return actions;
  }

  void _submit() async {
    if (!context.read<AuthProvider>().isLoggedIn) {
      LoginGate.show(
        context: context,
        title: 'Report Requires Login',
        description: 'Create an account to submit and track incident reports.',
      );
      return;
    }

    final risk = _generateRiskLevel();
    final reportId = 'CYB-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    final report = {
      'id': reportId,
      'type': _incidentType,
      'description': _descCtrl.text,
      'date': _incidentDate.toIso8601String(),
      'platform': _platform,
      'risk': risk,
      'timestamp': DateTime.now().toIso8601String(),
      'suspect': {
        'phone': _suspectPhoneCtrl.text,
        'email': _suspectEmailCtrl.text,
        'website': _suspectWebsiteCtrl.text,
        'username': _suspectUsernameCtrl.text,
      },
    };

    final box = await Hive.openBox(AppConstants.hiveBoxReports);
    await box.put(reportId, report);

    setState(() {
      _submitted = true;
      _reportId = reportId;
      _riskLevel = risk;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccessView();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _step == 0 ? 'Report Incident' : 'Step $_step of 7',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_step > 0 && _step < 7)
            TextButton(
              onPressed: _submit,
              child: Text('Submit', style: AppTypography.buttonSmall.copyWith(color: AppColors.primary)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          if (_step > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                height: 4,
                color: AppColors.border,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _step / 7,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                    ),
                  ),
                ),
              ),
            ),
          ],
          Expanded(child: _buildStepContent()),
          // Navigation buttons
          if (_step > 0 && _step < 7)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_step > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: const Text('BACK'),
                      ),
                    ),
                  if (_step > 1) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _step < 7 ? _nextStep : _submit,
                      child: Text(_step < 7 ? 'NEXT' : 'SUBMIT'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0: return _buildStep0Intro();
      case 1: return _buildStep1Type();
      case 2: return _buildStep2Description();
      case 3: return _buildStep3DateTime();
      case 4: return _buildStep4Platform();
      case 5: return _buildStep5Suspect();
      case 6: return _buildStep6Evidence();
      case 7: return _buildStep7Review();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep0Intro() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.errorBg, shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber, color: AppColors.error, size: 48),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Report a Cyber Incident',
          style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Report cybersecurity incidents securely. All data is stored locally on your device.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _benefitRow('7-step guided process'),
        _benefitRow('Automatic risk analysis'),
        _benefitRow('Recovery recommendations'),
        _benefitRow('Export and share reports'),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(onPressed: _nextStep, child: const Text('START REPORT')),
        ),
      ],
    );
  }

  Widget _benefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 18),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.body.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildStep1Type() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('INCIDENT TYPE', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 12),
        ..._incidentTypes.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => setState(() => _incidentType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _incidentType == type ? AppColors.primaryBg : AppColors.surface,
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(
                      color: _incidentType == type ? AppColors.primary : AppColors.border,
                      width: _incidentType == type ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _incidentType == type ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _incidentType == type ? AppColors.primary : AppColors.textTertiary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(type, style: AppTypography.body.copyWith(
                        color: _incidentType == type ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: _incidentType == type ? FontWeight.w600 : FontWeight.normal,
                      )),
                    ],
                  ),
                ),
              ),
            )),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _nextStep, child: const Text('NEXT'))),
      ],
    );
  }

  Widget _buildStep2Description() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DESCRIBE THE INCIDENT', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('Provide as much detail as possible about what happened.', style: AppTypography.bodySm.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _descCtrl,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Describe what happened, when, and who was involved...',
                hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3DateTime() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DATE & TIME', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('When did the incident occur?', style: AppTypography.bodySm.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 24),
          // Date picker
          GlassCard(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _incidentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface),
                ), child: child!),
              );
              if (date != null) setState(() => _incidentDate = date);
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  '${_incidentDate.day}/${_incidentDate.month}/${_incidentDate.year}',
                  style: AppTypography.bodyLg.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Time picker
          GlassCard(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _incidentTime,
                builder: (ctx, child) => Theme(data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface),
                ), child: child!),
              );
              if (time != null) setState(() => _incidentTime = time);
            },
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  _incidentTime.format(context),
                  style: AppTypography.bodyLg.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Platform() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('PLATFORM', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Text('Where did this incident occur?', style: AppTypography.bodySm.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _platforms.map((p) => GestureDetector(
            onTap: () => setState(() => _platform = p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _platform == p ? AppColors.primaryBg : AppColors.surface,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(
                  color: _platform == p ? AppColors.primary : AppColors.border,
                  width: _platform == p ? 1.5 : 0.5,
                ),
              ),
              child: Text(p, style: AppTypography.body.copyWith(
                color: _platform == p ? AppColors.primary : AppColors.textPrimary,
                fontWeight: _platform == p ? FontWeight.w600 : FontWeight.normal,
              )),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildStep5Suspect() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('SUSPECT INFORMATION', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Text('Any information you have about the perpetrator (optional).', style: AppTypography.bodySm.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 16),
        _suspectField('Phone Number', 'e.g. +628123456789', _suspectPhoneCtrl, Icons.phone),
        const SizedBox(height: 12),
        _suspectField('Email Address', 'e.g. suspect@email.com', _suspectEmailCtrl, Icons.email),
        const SizedBox(height: 12),
        _suspectField('Website / URL', 'e.g. https://fake-site.com', _suspectWebsiteCtrl, Icons.language),
        const SizedBox(height: 12),
        _suspectField('Username', 'e.g. scammer123', _suspectUsernameCtrl, Icons.person),
      ],
    );
  }

  Widget _suspectField(String label, String hint, TextEditingController ctrl, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textTertiary),
            prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 18),
            filled: true, fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStep6Evidence() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EVIDENCE', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('Upload screenshots or files as evidence (optional).', style: AppTypography.bodySm.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File picker would open here in a full build.')),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload, color: AppColors.textTertiary, size: 40),
                  const SizedBox(height: 8),
                  Text('Tap to upload evidence', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                  Text('Images, PDFs, or screenshots', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
          ),
          if (_evidencePaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._evidencePaths.map((e) => ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: AppColors.primary),
                  title: Text(e, style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                    onPressed: () => setState(() => _evidencePaths.remove(e)),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildStep7Review() {
    final risk = _generateRiskLevel();
    final actions = _generateActions();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('REVIEW REPORT', style: AppTypography.label.copyWith(color: AppColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 16),
        _reviewRow('Incident Type', _incidentType ?? 'N/A'),
        _reviewRow('Description', _descCtrl.text.length > 50 ? '${_descCtrl.text.substring(0, 50)}...' : _descCtrl.text),
        _reviewRow('Date', '${_incidentDate.day}/${_incidentDate.month}/${_incidentDate.year}'),
        _reviewRow('Platform', _platform ?? 'N/A'),
        _reviewRow('Suspect', _suspectUsernameCtrl.text.isNotEmpty ? _suspectUsernameCtrl.text : 'N/A'),
        const SizedBox(height: 16),

        // Risk analysis
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: risk == 'Critical' ? AppColors.errorBg : risk == 'High' ? AppColors.warningBg : AppColors.successBg,
            borderRadius: AppSpacing.borderRadiusSm,
            border: Border.all(
              color: risk == 'Critical' ? AppColors.error.withOpacity(0.3) : risk == 'High' ? AppColors.warning.withOpacity(0.3) : AppColors.success.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('SMART ANALYSIS', style: AppTypography.label.copyWith(color: AppColors.primary, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 12),
              _analysisRow('Risk Level', risk, risk == 'Critical' ? AppColors.error : risk == 'High' ? AppColors.warning : AppColors.success),
              const SizedBox(height: 8),
              _analysisRow('Possible Threat', _incidentType ?? 'Unknown', AppColors.textPrimary),
              const SizedBox(height: 12),
              Text('Recommended Actions:', style: AppTypography.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...actions.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: AppColors.primary)),
                        Expanded(child: Text(a, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: _submit, child: const Text('SUBMIT REPORT'))),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTypography.caption.copyWith(color: AppColors.textTertiary))),
          Expanded(child: Text(value, style: AppTypography.body.copyWith(color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _analysisRow(String label, String value, Color color) {
    return Row(
      children: [
        Text('$label: ', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(value, style: AppTypography.overline.copyWith(color: color, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    final risk = _riskLevel ?? 'Low';
    final riskColor = risk == 'Critical' ? AppColors.error : risk == 'High' ? AppColors.warning : AppColors.success;

    return Scaffold(
      appBar: AppBar(title: Text('Report Submitted', style: AppTypography.h3.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700))),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
              ),
            ),
            const SizedBox(height: 24),
            Text('Report Submitted', style: AppTypography.h2.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('Report ID', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 4),
                  Text(_reportId ?? '', style: AppTypography.h4.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _analysisRow('Risk Level', risk, riskColor),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
              onPressed: () => setState(() {
                _step = 0; _submitted = false; _incidentType = null;
                _descCtrl.clear();
              }),
              child: const Text('REPORT ANOTHER INCIDENT'),
            )),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 48, child: OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report saved locally on your device.')),
              ),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.border)),
              child: const Text('VIEW REPORT HISTORY'),
            )),
          ],
        ),
      ),
    );
  }
}

/// Glass card for date/time picker buttons
class GlassCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  const GlassCard({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}
