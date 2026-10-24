import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/welcome_family_illustration.dart';
import '../../../authentication/presentation/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  void _goToCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void _goToLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Próxima etapa: entrar na conta.')),
    );

    // Futuramente:
    // Navigator.pushNamed(context, '/login');
  }

  void _showMoreInformation(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return const _AboutPlatformBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 44,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const _WelcomeHeader(),
                      const SizedBox(height: 28),
                      const WelcomeFamilyIllustration(),
                      const SizedBox(height: 24),
                      Text(
                        'Bem-vindo à\nFamília Reunida',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.14,
                              letterSpacing: -0.6,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'O espaço seguro para preservar histórias, fortalecer laços e manter viva a memória da sua família.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () => _goToCreateAccount(context),
                        child: const Text('Criar conta'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => _goToLogin(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Já tenho uma conta'),
                      ),
                      const SizedBox(height: 18),
                      TextButton.icon(
                        onPressed: () => _showMoreInformation(context),
                        icon: const Icon(Icons.info_outline_rounded, size: 19),
                        label: const Text('Conhecer melhor a plataforma'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      const _PrivacyMessage(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_tree_rounded, color: AppColors.primary, size: 26),
        SizedBox(width: 9),
        Text(
          'Família Reunida',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PrivacyMessage extends StatelessWidget {
  const _PrivacyMessage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textSecondary,
          size: 16,
        ),
        SizedBox(width: 7),
        Flexible(
          child: Text(
            'As memórias da sua família permanecem protegidas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutPlatformBottomSheet extends StatelessWidget {
  const _AboutPlatformBottomSheet();

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sobre a Família Reunida',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'A Família Reunida é um sistema de gestão familiar criado '
                'para organizar pessoas, relações, fotografias, documentos, '
                'histórias e memórias.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 20),

              const _PlatformFeature(
                icon: Icons.account_tree_outlined,
                title: 'Árvore familiar',
                description:
                    'Organize parentes e relações entre gerações.',
              ),

              const _PlatformFeature(
                icon: Icons.photo_library_outlined,
                title: 'Memórias',
                description:
                    'Preserve fotografias, histórias e momentos.',
              ),

              const _PlatformFeature(
                icon: Icons.folder_copy_outlined,
                title: 'Documentos',
                description:
                    'Guarde documentos importantes da família.',
              ),

              const _PlatformFeature(
                icon: Icons.shield_outlined,
                title: 'Privacidade',
                description:
                    'Controle quem pode visualizar cada informação.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformFeature extends StatelessWidget {
  const _PlatformFeature({
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
      padding: const EdgeInsets.only(bottom: 16),
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
            child: Icon(icon, color: AppColors.primary, size: 22),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
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
