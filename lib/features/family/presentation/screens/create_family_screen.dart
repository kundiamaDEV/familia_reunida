import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../authentication/presentation/widgets/auth_text_field.dart';
import '../../providers/family_providers.dart';

class CreateFamilyScreen extends ConsumerStatefulWidget {
  const CreateFamilyScreen({super.key});

  static const String routeName = '/create-family';

  @override
  ConsumerState<CreateFamilyScreen> createState() =>
      _CreateFamilyScreenState();
}

class _CreateFamilyScreenState
    extends ConsumerState<CreateFamilyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _officialNameController =
      TextEditingController();

  final TextEditingController _shortNameController =
      TextEditingController();

  final TextEditingController _familyNicknameController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  String? _selectedCountry;
  String? _selectedProvince;

  final List<String> _countries = const [
    'Angola',
    'Brasil',
    'Cabo Verde',
    'Guiné-Bissau',
    'Moçambique',
    'Portugal',
    'São Tomé e Príncipe',
    'Outro',
  ];

  final List<String> _angolaProvinces = const [
    'Bengo',
    'Benguela',
    'Bié',
    'Cabinda',
    'Cuando',
    'Cubango',
    'Cuanza Norte',
    'Cuanza Sul',
    'Cunene',
    'Huambo',
    'Huíla',
    'Icolo e Bengo',
    'Luanda',
    'Lunda Norte',
    'Lunda Sul',
    'Malanje',
    'Moxico',
    'Moxico Leste',
    'Namibe',
    'Uíge',
    'Zaire',
  ];

  @override
  void dispose() {
    _officialNameController.dispose();
    _shortNameController.dispose();
    _familyNicknameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  String? _validateOfficialName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Informe o nome oficial da família.';
    }

    if (text.length < 4) {
      return 'O nome deve possuir pelo menos 4 caracteres.';
    }

    if (text.length > 100) {
      return 'O nome deve possuir no máximo 100 caracteres.';
    }

    return null;
  }

  String? _validateShortName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Informe um nome curto.';
    }

    if (text.length < 2) {
      return 'O nome curto deve possuir pelo menos 2 caracteres.';
    }

    if (text.length > 20) {
      return 'O nome curto deve possuir no máximo 20 caracteres.';
    }

    return null;
  }

  String? _validateNickname(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (text.length > 30) {
      return 'O apelido deve possuir no máximo 30 caracteres.';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    if (text.length > 300) {
      return 'A descrição deve possuir no máximo 300 caracteres.';
    }

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_selectedCountry == null) {
      _showMessage(
        'Selecione o país de origem ou referência.',
      );

      return;
    }

    if (_selectedCountry == 'Angola' &&
        _selectedProvince == null) {
      _showMessage(
        'Selecione a província de referência.',
      );

      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _showMessage(
        'É necessário estar autenticado para criar uma família.',
      );

      return;
    }

    final controller = ref.read(
      familySetupControllerProvider.notifier,
    );

    await controller.createFamily(
      officialName: _officialNameController.text,
      shortName: _shortNameController.text,
      nickname: _familyNicknameController.text,
      country: _selectedCountry!,
      province: _selectedProvince,
      description: _descriptionController.text,
      createdBy: currentUser.uid,
      familyCode: _generateFamilyCode(),
      inviteCode: _generateInviteCode(),
    );

    if (!mounted) {
      return;
    }

    final state = ref.read(
      familySetupControllerProvider,
    );

    if (state.isSuccess && state.family != null) {
      _showMessage(
        'Família "${state.family!.displayName}" criada com sucesso.',
      );

      return;
    }

    if (state.hasError) {
      _showMessage(
        state.errorMessage ??
            'Não foi possível criar a família.',
      );
    }
  }

  String _generateFamilyCode() {
    final shortName = _shortNameController.text
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final timestamp = DateTime.now()
        .microsecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();

    final suffix = timestamp.length > 6
        ? timestamp.substring(timestamp.length - 6)
        : timestamp;

    final normalizedShortName =
        shortName.isEmpty ? 'FAMILIA' : shortName;

    return 'FR-$normalizedShortName-$suffix';
  }

  String _generateInviteCode() {
    final timestamp = DateTime.now()
        .microsecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();

    final suffix = timestamp.length > 8
        ? timestamp.substring(timestamp.length - 8)
        : timestamp;

    return 'CONV-$suffix';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familySetupState = ref.watch(
      familySetupControllerProvider,
    );

    final isSubmitting = familySetupState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Criar família',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              24,
              18,
              24,
              32,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const _CreateFamilyHeader(),

                const SizedBox(height: 28),

                AuthTextField(
                  controller: _officialNameController,
                  label: 'Nome oficial da família',
                  hint: 'Ex.: Família Manuel Simão',
                  prefixIcon: Icons.groups_2_outlined,
                  keyboardType: TextInputType.name,
                  textInputAction:
                      TextInputAction.next,
                  validator: _validateOfficialName,
                ),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _shortNameController,
                  label: 'Nome curto',
                  hint: 'Ex.: Simão',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.name,
                  textInputAction:
                      TextInputAction.next,
                  validator: _validateShortName,
                ),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _familyNicknameController,
                  label: 'Apelido familiar',
                  hint: 'Opcional',
                  prefixIcon:
                      Icons.favorite_border_rounded,
                  keyboardType: TextInputType.name,
                  textInputAction:
                      TextInputAction.next,
                  validator: _validateNickname,
                ),

                const SizedBox(height: 16),

                _FamilyDropdownField(
                  label:
                      'País de origem ou referência',
                  hint: 'Selecione o país',
                  icon: Icons.public_rounded,
                  value: _selectedCountry,
                  items: _countries,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;

                      if (value != 'Angola') {
                        _selectedProvince = null;
                      }
                    });
                  },
                ),

                if (_selectedCountry == 'Angola') ...[
                  const SizedBox(height: 16),
                  _FamilyDropdownField(
                    label:
                        'Província de referência',
                    hint:
                        'Selecione a província',
                    icon:
                        Icons.location_on_outlined,
                    value: _selectedProvince,
                    items: _angolaProvinces,
                    onChanged: (value) {
                      setState(() {
                        _selectedProvince = value;
                      });
                    },
                  ),
                ],

                const SizedBox(height: 16),

                _FamilyDescriptionField(
                  controller:
                      _descriptionController,
                  validator:
                      _validateDescription,
                ),

                const SizedBox(height: 22),

                const _FamilyIdentityHint(),

                const SizedBox(height: 26),

                FilledButton(
                  onPressed:
                      isSubmitting ? null : _submit,
                  child: AnimatedSwitcher(
                    duration:
                        const Duration(milliseconds: 200),
                    child: isSubmitting
                        ? const SizedBox(
                            key: ValueKey(
                              'family-loading',
                            ),
                            width: 23,
                            height: 23,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: AppColors.white,
                            ),
                          )
                        : const Row(
                            key: ValueKey(
                              'family-label',
                            ),
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                'Criar família',
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons
                                    .arrow_forward_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                const _PrivacyMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateFamilyHeader
    extends StatelessWidget {
  const _CreateFamilyHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.08,
            ),
            borderRadius:
                BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.add_home_work_outlined,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Defina a identidade da família',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontSize: 21,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Estas informações serão utilizadas no perfil familiar e nos convites enviados aos membros.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color:
                AppColors.secondary.withValues(
              alpha: 0.16,
            ),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: const Text(
            'Passo 2 de 3',
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

class _FamilyDropdownField
    extends StatelessWidget {
  const _FamilyDropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                AppColors.primary.withValues(
              alpha: 0.12,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
      items: items
          .map(
            (item) =>
                DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FamilyDescriptionField
    extends StatelessWidget {
  const _FamilyDescriptionField({
    required this.controller,
    required this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      minLines: 4,
      maxLines: 6,
      maxLength: 300,
      textInputAction:
          TextInputAction.newline,
      decoration: InputDecoration(
        labelText: 'Descrição da família',
        hintText:
            'Escreva uma pequena apresentação sobre a origem, história ou valores da família.',
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding:
              EdgeInsets.only(bottom: 72),
          child: Icon(
            Icons.menu_book_outlined,
            color: AppColors.primary,
          ),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                AppColors.primary.withValues(
              alpha: 0.12,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _FamilyIdentityHint
    extends StatelessWidget {
  const _FamilyIdentityHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            AppColors.secondary.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.primary,
            size: 21,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Utilize um nome reconhecido por todos os familiares. Poderá alterar estas informações posteriormente.',
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

class _PrivacyMessage
    extends StatelessWidget {
  const _PrivacyMessage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textSecondary,
          size: 16,
        ),
        SizedBox(width: 7),
        Flexible(
          child: Text(
            'O perfil da família será privado e acessível apenas aos membros.',
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