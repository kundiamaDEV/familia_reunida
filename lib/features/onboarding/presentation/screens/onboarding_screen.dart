import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/onboarding_page_content.dart';
import '../../../welcome/presentation/screens/welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      icon: Icons.history_edu_rounded,
      title: 'Preserve a história da sua família',
      description:
          'Guarde histórias, fotografias, documentos e momentos importantes para que nunca sejam esquecidos.',
      backgroundColor: AppColors.background,
      iconBackgroundColor: Color(0xFFF5E8C7),
    ),
    _OnboardingItem(
      icon: Icons.groups_rounded,
      title: 'Conecte todas as gerações',
      description:
          'Aproxime avós, pais, filhos, netos e familiares, fortalecendo os laços que unem a família.',
      backgroundColor: Color(0xFFF2F7F4),
      iconBackgroundColor: Color(0xFFDCECE5),
    ),
    _OnboardingItem(
      icon: Icons.account_tree_rounded,
      title: 'Construa um legado familiar',
      description:
          'Crie a árvore genealógica da família e preserve um património de memórias para as próximas gerações.',
      backgroundColor: Color(0xFFFBF7EF),
      iconBackgroundColor: Color(0xFFF1DFB4),
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goToNextPage() {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
    );
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];

              return OnboardingPageContent(
                icon: page.icon,
                title: page.title,
                description: page.description,
                backgroundColor: page.backgroundColor,
                iconBackgroundColor: page.iconBackgroundColor,
              );
            },
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
                child: Row(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_tree_rounded,
                          color: AppColors.primary,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Família Reunida',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isLastPage ? 0 : 1,
                      child: IgnorePointer(
                        ignoring: _isLastPage,
                        child: TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text(
                            'Saltar',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(
                        _pages.length,
                        (index) =>
                            _PageIndicator(isActive: index == _currentPage),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isLastPage ? 150 : 58,
                    height: 58,
                    child: FilledButton(
                      onPressed: _goToNextPage,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 58),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _isLastPage
                            ? const Row(
                                key: ValueKey('start'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Começar',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              )
                            : const Icon(
                                Icons.arrow_forward_rounded,
                                key: ValueKey('next'),
                                size: 24,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: isActive ? 30 : 9,
      height: 9,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: .20),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconBackgroundColor;
}
