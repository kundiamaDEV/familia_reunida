import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_text_field.dart';
import 'verify_contact_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String? _validateFullName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Informe o seu nome completo.';
    }

    if (name.length < 5) {
      return 'O nome deve possuir pelo menos 5 caracteres.';
    }

    if (!name.contains(' ')) {
      return 'Informe pelo menos o primeiro e o último nome.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone =
        value
            ?.replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('(', '')
            .replaceAll(')', '') ??
        '';

    if (phone.isEmpty) {
      return 'Informe o número de telefone.';
    }

    if (!RegExp(r'^(?:\+244)?9\d{8}$').hasMatch(phone)) {
      return 'Informe um número angolano válido.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return null;
    }

    final emailExpression = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailExpression.hasMatch(email)) {
      return 'Informe um endereço de email válido.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Crie uma palavra-passe.';
    }

    if (password.length < 8) {
      return 'A palavra-passe deve possuir pelo menos 8 caracteres.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Adicione pelo menos uma letra maiúscula.';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Adicione pelo menos um número.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme a palavra-passe.';
    }

    if (value != _passwordController.text) {
      return 'As palavras-passe não coincidem.';
    }

    return null;
  }

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Aceite os Termos de Utilização e a Política de Privacidade.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dados validados. Próxima etapa: verificação do contacto.',
        ),
      ),
    );

    Navigator.pushNamed(
      context,
      VerifyContactScreen.routeName,
      arguments: _phoneController.text.trim(),
    );
  }

  void _openTerms() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return const _TermsBottomSheet();
      },
    );
  }

  void _goToLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A tela de login será implementada na próxima fase.'),
      ),
    );

    // Futuramente:
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Criar conta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _RegisterIntroduction(),
                  const SizedBox(height: 30),

                  AuthTextField(
                    controller: _fullNameController,
                    label: 'Nome completo',
                    hint: 'Ex.: Ana Manuel da Silva',
                    prefixIcon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _validateFullName,
                    autofillHints: const [AutofillHints.name],
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    controller: _phoneController,
                    label: 'Número de telefone',
                    hint: 'Ex.: 923 456 789',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: _validatePhone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Opcional',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    autofillHints: const [AutofillHints.email],
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    controller: _passwordController,
                    label: 'Palavra-passe',
                    hint: 'Mínimo de 8 caracteres',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _hidePassword,
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar palavra-passe',
                    hint: 'Repita a palavra-passe',
                    prefixIcon: Icons.lock_reset_rounded,
                    obscureText: _hideConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    autofillHints: const [AutofillHints.newPassword],
                    onFieldSubmitted: (_) {
                      _submitRegistration();
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const _PasswordRequirements(),

                  const SizedBox(height: 22),

                  _TermsAgreement(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    onOpenTerms: _openTerms,
                  ),

                  const SizedBox(height: 24),

                  FilledButton(
                    onPressed: _isSubmitting ? null : _submitRegistration,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isSubmitting
                          ? const SizedBox(
                              key: ValueKey('register-loading'),
                              width: 23,
                              height: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: AppColors.white,
                              ),
                            )
                          : const Row(
                              key: ValueKey('register-label'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Continuar'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Já possui uma conta?',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _goToLogin,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const _SecurityInformation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterIntroduction extends StatelessWidget {
  const _RegisterIntroduction();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: AppColors.primary,
            size: 27,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Comece a preservar a história da sua família',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 27,
            height: 1.2,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Crie a sua conta pessoal. Depois poderá criar ou juntar-se ao espaço privado da sua família.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 19),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Utilize pelo menos 8 caracteres, incluindo uma letra maiúscula e um número.',
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

class _TermsAgreement extends StatelessWidget {
  const _TermsAgreement({
    required this.value,
    required this.onChanged,
    required this.onOpenTerms,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onOpenTerms;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-5, -6),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Li e aceito os ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              GestureDetector(
                onTap: onOpenTerms,
                child: const Text(
                  'Termos de Utilização',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
              const Text(
                ' e a ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              GestureDetector(
                onTap: onOpenTerms,
                child: const Text(
                  'Política de Privacidade.',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityInformation extends StatelessWidget {
  const _SecurityInformation();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 16),
        SizedBox(width: 7),
        Flexible(
          child: Text(
            'Os seus dados serão utilizados apenas para proteger e gerir a sua conta.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsBottomSheet extends StatelessWidget {
  const _TermsBottomSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Termos e privacidade',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Ao criar uma conta, compromete-se a fornecer informações verdadeiras e a respeitar a privacidade dos restantes membros da família.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
            const _TermsItem(
              icon: Icons.lock_outline_rounded,
              title: 'Proteção dos dados',
              description:
                  'As informações familiares serão tratadas como privadas e protegidas.',
            ),
            const _TermsItem(
              icon: Icons.groups_outlined,
              title: 'Respeito entre membros',
              description:
                  'Cada utilizador deve respeitar a dignidade e a memória dos familiares.',
            ),
            const _TermsItem(
              icon: Icons.verified_user_outlined,
              title: 'Responsabilidade',
              description:
                  'O utilizador é responsável pelas informações e documentos que adicionar.',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compreendi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsItem extends StatelessWidget {
  const _TermsItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
