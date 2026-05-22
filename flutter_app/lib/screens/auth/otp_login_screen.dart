import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_logo.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final ok = _otpSent
        ? await auth.verifyOtp(_otp.text.trim())
        : await auth.sendOtp(_phone.text.trim());
    if (!mounted) return;
    if (ok && !_otpSent) {
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent')));
      return;
    }
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('OTP Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLogo(size: LogoSize.medium),
            const SizedBox(height: 24),
            Text(_otpSent ? 'Enter OTP' : 'Enter mobile number (+91 default)'),
            const SizedBox(height: 16),
            if (!_otpSent)
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone', hintText: '9876543210'),
              )
            else
              TextField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '6-digit OTP'),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.isLoading ? null : _submit,
              child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
