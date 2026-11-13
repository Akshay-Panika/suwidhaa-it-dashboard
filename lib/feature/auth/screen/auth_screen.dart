import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suwidhaa_it_service_dashboard/feature/main/screen/main_screen.dart';

import '../../../core/utils/app_color.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  // ── Demo Credentials ──
  static const _adminEmail = 'admin@gmail.com';
  static const _adminPass = 'admin@123';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // fake small delay for UX (optional — remove if not needed)
    await Future.delayed(const Duration(milliseconds: 700));

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email == _adminEmail && pass == _adminPass) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);

      if (!mounted) return;
      setState(() => _loading = false);

      Fluttertoast.showToast(
        msg: 'Login successful. Welcome back!',
        backgroundColor: AppColor.primary,
        textColor: AppColor.white,
        gravity: ToastGravity.BOTTOM,
      );

      Get.offAll(() => const MainScreen());
    } else {
      if (!mounted) return;
      setState(() => _loading = false);

      Fluttertoast.showToast(
        msg: 'Invalid email or password.',
        backgroundColor: AppColor.red,
        textColor: AppColor.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColor.bg,
      body: isWeb ? _webLayout() : _mobileLayout(),
    );
  }

  // ═══════════════════════════════════════════════
  //  LAYOUTS
  // ═══════════════════════════════════════════════
  Widget _webLayout() {
    return Row(
      children: [
        Expanded(flex: 5, child: _brandPanel()),
        Expanded(flex: 5, child: _formPanel(showCard: false)),
      ],
    );
  }

  Widget _mobileLayout() {
    return _formPanel(showCard: true);
  }

  // ═══════════════════════════════════════════════
  //  LEFT BRAND PANEL (web only)
  // ═══════════════════════════════════════════════
  Widget _brandPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, Color(0xFF6D28D9)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppColor.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                 Text(
                  'SUWIDHAA',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
             Text(
              'Unified Dashboard\nfor IT Services',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Manage students, classes, OTT content,\nand reports — all in one place.',
              style: TextStyle(
                color: AppColor.white.withOpacity(0.85),
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            _featureRow(Icons.shield_outlined, 'Secure & Role-based Access'),
            const SizedBox(height: 16),
            _featureRow(Icons.bolt_outlined, 'Fast & Responsive on Any Device'),
            const SizedBox(height: 16),
            _featureRow(Icons.insights_outlined, 'Real-time Analytics & Reports'),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColor.white, size: 18),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: TextStyle(
            color: AppColor.white.withOpacity(0.95),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  RIGHT FORM PANEL
  // ═══════════════════════════════════════════════
  Widget _formPanel({required bool showCard}) {
    final content = _loginForm();

    final body = Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: showCard ? 20 : 40,
          vertical: 40,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: showCard
              ? Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: content,
          )
              : content,
        ),
      ),
    );

    return body;
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
           Text(
            'Welcome back 👋',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to your Suwidhaa dashboard',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),

          // ── Email ──
          _label('Email Address'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              'Enter your email',
              Icons.mail_outline_rounded,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              final ok = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$')
                  .hasMatch(v.trim());
              if (!ok) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // ── Password ──
          _label('Password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            decoration: _inputDecoration(
              'Enter your password',
              Icons.lock_outline_rounded,
            ).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters required';
              return null;
            },
          ),
          const SizedBox(height: 28),

          // ── Login Button ──
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                disabledBackgroundColor: AppColor.primary.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ?  SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColor.white),
                ),
              )
                  : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Demo credentials hint ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.primary.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColor.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        'Demo Credentials',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColor.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'admin@gmail.com  •  admin@123',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════
  Widget _label(String text) {
    return Text(
      text,
      style:  TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
      filled: true,
      fillColor: AppColor.bg,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.red.withOpacity(0.7)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.red),
      ),
    );
  }
}