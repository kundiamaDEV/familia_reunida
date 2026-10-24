import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/family_setup_option_card.dart';
import 'create_family_screen.dart';

class FamilySetupScreen extends StatelessWidget {
  const FamilySetupScreen({super.key});

  static const String routeName = '/family-setup';

  void _createFamily(BuildContext context) {
    Navigator.pushNamed(context, CreateFamilyScreen.routeName);
  }

  void _joinFamily(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Próxima etapa: juntar-se através de um convite.'),
      ),
    );

    // Será substituído depois por:
    // Navigator.pushNamed(
    //   context,
    //   JoinFamilyScreen.routeName,
    // );
  }

  void _showExplanation(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      builder: (_) => const _FamilySetupExplanation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FamilySetupHeader(),
                const SizedBox(height: 34),
                Text(
                  'Como deseja começar?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 28,
                    height: 1.18,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Para continuar, crie o espaço privado da sua família ou utilize um convite enviado por outro familiar.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 30),
                FamilySetupOptionCard(
                  icon: Icons.add_home_work_outlined,
                  title: 'Criar uma nova família',
                  description:
                      'Crie o espaço principal, defina o nome da família e convide os primeiros membros.',
                  actionLabel: 'Criar família',
                  isPrimary: true,
                  onTap: () => _createFamily(context),
                ),
                const SizedBox(height: 18),
                FamilySetupOptionCard(
                  icon: Icons.mark_email_read_outlined,
                  title: 'Juntar-me a uma família',
                  description:
                      'Utilize o código ou o link de convite enviado por um membro autorizado.',
                  actionLabel: 'Utilizar convite',
                  onTap: () => _joinFamily(context),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showExplanation(context),
                    icon: const Icon(Icons.help_outline_rounded, size: 19),
                    label: const Text('Qual opção devo escolher?'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const _PrivacyNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FamilySetupHeader extends StatelessWidget {
  const _FamilySetupHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.account_tree_rounded,
            color: AppColors.primary,
            size: 25,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Família Reunida',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Configuração inicial',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Passo 1 de 3',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 20),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Cada família possui um espaço privado. Apenas pessoas convidadas ou autorizadas poderão entrar.',
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

class _FamilySetupExplanation extends StatelessWidget {
  const _FamilySetupExplanation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Qual opção escolher?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const _ExplanationItem(
              icon: Icons.add_home_work_outlined,
              title: 'Criar uma nova família',
              description:
                  'Escolha esta opção quando for o primeiro membro a configurar o espaço digital da sua família.',
            ),
            const _ExplanationItem(
              icon: Icons.mark_email_read_outlined,
              title: 'Juntar-se a uma família',
              description:
                  'Escolha esta opção quando outro familiar já tiver criado o espaço e enviado um convite.',
            ),
            const SizedBox(height: 8),
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

class _ExplanationItem extends StatelessWidget {
  const _ExplanationItem({
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
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
                const SizedBox(height: 5),
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
