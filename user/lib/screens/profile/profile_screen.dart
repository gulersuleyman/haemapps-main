import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/bloc/user/user_bloc.dart';
import 'package:user/screens/profile/obtain_account.dart';
import 'package:user/screens/settings/settings_screen.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isAnonymous = EpiFirebaseAuth.instance.currentUser!.isAnonymous;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return ListView(
              padding: context.mediumHorizontalPadding,
              children: [
                if (isAnonymous) ...[
                  const SizedBox(height: 40),
                  Center(child: Text('Anonim Hesap', style: context.theme.textTheme.labelMedium)),
                  Center(child: Text('Hesabınızı sahiplenin', style: context.theme.textTheme.bodyLarge)),
                  Center(child: Text('Bilgilerinizi kaybetmeyin', style: context.theme.textTheme.bodyLarge)),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => const ObtainAccount(),
                          ),
                        )
                            .then((_) {
                          setState(() {
                            isAnonymous = EpiFirebaseAuth.instance.currentUser!.isAnonymous;
                          });
                        });
                      },
                      child: const Text('Hemen Kayıt Ol'),
                    ),
                  ),
                ],
                if (!isAnonymous) ...[
                  AccountForm(userName: state.user.name ?? '', userPhone: state.user.phone ?? ''),
                ],
              ],
            );
          } else {
            return const Center(child: WaveDots());
          }
        },
      ),
    );
  }
}

class AccountForm extends StatefulWidget {
  final String userName;
  final String userPhone;

  const AccountForm({super.key, required this.userName, required this.userPhone});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _phoneController.text = widget.userPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        EpiTextField(
          title: 'Adınız',
          placeholder: 'Adınız',
          controller: _nameController,
          keyboardType: TextInputType.name,
        ),
        context.tinyGap,
        EpiTextField(
          title: 'Telefon Numaranız',
          placeholder: 'Telefon Numaranız',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        context.mediumGap,
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () async {
              if (isLoading) return;
              setState(() => isLoading = true);

              await FirebaseFirestore.instance.collection('users').doc(EpiFirebaseAuth.instance.currentUser!.uid).update({
                'name': _nameController.text,
                'phone': _phoneController.text,
              });

              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bilgileriniz başarıyla güncellendi')));
            },
            child: isLoading ? const SizedBox(width: 20, height: 20, child: WaveDots(color: Colors.white)) : const Text('Bilgileri Güncelle'),
          ),
        ),
      ],
    );
  }
}
