import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../family/presentation/screens/family_setup_screen.dart';

class VerifyContactScreen extends StatefulWidget {
  const VerifyContactScreen({required this.phoneNumber, super.key});

  static const String routeName = '/verify-contact';

  final String phoneNumber;

  @override
  State<VerifyContactScreen> createState() => _VerifyContactScreenState();
}

class _VerifyContactScreenState extends State<VerifyContactScreen> {
  static const int _codeLength = 6;
  static const int _initialSeconds = 60;

  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  Timer? _timer;

  int _remainingSeconds = _initialSeconds;
  bool _isVerifying = false;
  bool _canResend = false;

  String get _verificationCode =>
      _controllers.map((controller) => controller.text).join();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = _initialSeconds;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();

        if (!mounted) return;

        setState(() {
          _remainingSeconds = 0;
          _canResend = true;
        });

        return;
      }

      if (!mounted) return;

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  void _handleCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});

    if (_verificationCode.length == _codeLength) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    FocusScope.of(context).unfocus();

    if (_verificationCode.length != _codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduza os seis dígitos do código.')),
      );

      return;
    }

    setState(() {
      _isVerifying = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    if (_verificationCode != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código inválido. Para teste, utilize 123456.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacto verificado com sucesso.')),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      FamilySetupScreen.routeName,
      (route) => false,
    );
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    for (final controller in _controllers) {
      controller.clear();
    }

    _focusNodes.first.requestFocus();

    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Um novo código foi enviado.')),
    );
  }

  String _maskedPhoneNumber() {
    final phone = widget.phoneNumber.trim();

    if (phone.length < 6) {
      return phone;
    }

    final visibleStart = phone.substring(0, 4);
    final visibleEnd = phone.substring(phone.length - 3);

    return '$visibleStart ••• ••$visibleEnd';
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCodeComplete = _verificationCode.length == _codeLength;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Verificar contacto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _VerificationIllustration(),

              const SizedBox(height: 30),

              Text(
                'Introduza o código recebido',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 27, height: 1.2),
              ),

              const SizedBox(height: 12),

              Text(
                'Enviámos um código de seis dígitos por SMS para',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _maskedPhoneNumber(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 34),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _codeLength,
                  (index) => _CodeDigitField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    isActive: _focusNodes[index].hasFocus,
                    onChanged: (value) {
                      _handleCodeChanged(value, index);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Para testar esta tela, utilize o código 123456.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              FilledButton(
                onPressed: !isCodeComplete || _isVerifying ? null : _verifyCode,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isVerifying
                      ? const SizedBox(
                          key: ValueKey('verification-loading'),
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppColors.white,
                          ),
                        )
                      : const Row(
                          key: ValueKey('verification-label'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Verificar código'),
                            SizedBox(width: 8),
                            Icon(Icons.verified_rounded, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              _ResendSection(
                remainingSeconds: _remainingSeconds,
                canResend: _canResend,
                onResend: _resendCode,
              ),

              const SizedBox(height: 28),

              const _SecurityNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeDigitField extends StatelessWidget {
  const _CodeDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isActive,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 58,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 23,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.14),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _VerificationIllustration extends StatelessWidget {
  const _VerificationIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.08),
      ),
      child: Center(
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFF2DFB0),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: 1.5),
          ),
          child: const Icon(
            Icons.sms_outlined,
            color: AppColors.primary,
            size: 38,
          ),
        ),
      ),
    );
  }
}

class _ResendSection extends StatelessWidget {
  const _ResendSection({
    required this.remainingSeconds,
    required this.canResend,
    required this.onResend,
  });

  final int remainingSeconds;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (canResend) {
      return TextButton.icon(
        onPressed: onResend,
        icon: const Icon(Icons.refresh_rounded, size: 19),
        label: const Text('Reenviar código'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      );
    }

    return Text(
      'Poderá solicitar um novo código em '
      '${remainingSeconds}s',
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: AppColors.primary, size: 21),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Nunca partilhe este código. A equipa da Família Reunida não solicitará o código por chamada ou mensagem.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
