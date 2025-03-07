import 'package:epi_extensions/epi_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user/widgets/epi_text_field.dart';

class ObtainAccount extends StatefulWidget {
  const ObtainAccount({super.key});

  @override
  State<ObtainAccount> createState() => _ObtainAccountState();
}

class _ObtainAccountState extends State<ObtainAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _obtainAccount() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _passwordConfirmController.text.isEmpty) {
      setState(() => _errorMessage = 'Lütfen tüm alanları doldurun');
      return;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() => _errorMessage = 'Şifreler eşleşmiyor');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      if (mounted) Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = switch (e.code) {
          'email-already-in-use' => 'Bu email adresi zaten kullanımda',
          'invalid-email' => 'Geçersiz email adresi',
          'weak-password' => 'Şifre çok zayıf',
          _ => 'Bir hata oluştu: ${e.message}',
        };
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabı Sahiplen'),
      ),
      body: ListView(
        padding: context.mediumHorizontalPadding,
        children: [
          Text(
            'Anonim hesabınızı kalıcı hale getirmek için email ve şifre oluşturun.',
            style: context.theme.textTheme.labelSmall,
          ),
          context.smallGap,
          EpiTextField(
            title: 'Email',
            placeholder: 'Email adresinizi girin',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hasError: _errorMessage?.contains('email') ?? false,
          ),
          context.smallGap,
          EpiTextField(
            title: 'Şifre',
            placeholder: 'Şifrenizi girin',
            controller: _passwordController,
            obscureText: true,
            hasError: _errorMessage?.contains('şifre') ?? false,
          ),
          context.smallGap,
          EpiTextField(
            title: 'Şifre Tekrar',
            placeholder: 'Şifrenizi tekrar girin',
            controller: _passwordConfirmController,
            obscureText: true,
            hasError: _errorMessage?.contains('şifre') ?? false,
          ),
          if (_errorMessage != null) ...[
            context.smallGap,
            Text(
              _errorMessage!,
              style: TextStyle(
                color: context.theme.colorScheme.error,
              ),
            ),
          ],
          context.smallGap,
          FilledButton(
            onPressed: _isLoading ? null : _obtainAccount,
            child: _isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Hesabı Sahiplen', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
