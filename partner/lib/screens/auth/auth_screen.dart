import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:partner/screens/auth/reset_password.dart';
import 'package:partner/widgets/epi_text_field.dart';
import 'package:partner/widgets/wave_dots.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  bool isRegister = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingTransparencyRequest();
    });
  }

  Future<String?> _trackingTransparencyRequest() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.authorized) {
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      return uuid;
    } else if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      return uuid;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: ListView(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  isRegister ? 'Haem Partner | Kayıt Ol' : 'Haem Partner | Giriş Yap',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EpiTextField(
                  controller: emailController,
                  placeholder: 'E-posta',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EpiTextField(
                  controller: passwordController,
                  placeholder: 'Şifre',
                  obscureText: true,
                ),
              ),
              context.smallGap,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email ve Şifre alanları boş olamaz.')));
                      return;
                    }

                    setState(() => isLoading = true);

                    if (isRegister) {
                      final EpiResponse<UserCredential?> response = await EpiFirebaseAuth.instance.signUpWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      if (response.status == Status.success) {
                        final id = response.data!.user!.uid;

                        final PartnerUser partnerUser = PartnerUser(
                          name: 'Haem Partner',
                          id: id,
                        );

                        await FirebaseFirestore.instance.collection('partners').doc(id).set(
                              partnerUser.toMap(),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? 'Bir hata oluştu.')));
                      }
                    } else {
                      final response = await EpiFirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      if (response.status != Status.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? 'Bir hata oluştu.')));
                        setState(() => isLoading = false);
                      }
                    }
                  },
                  child: isLoading
                      ? const Center(child: WaveDots(color: Colors.white))
                      : isRegister
                          ? const Text('Kayıt Ol')
                          : const Text('Giriş Yap'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isRegister = !isRegister;
                    });
                  },
                  child: isRegister ? const Text('Hesabınız var mı? Giriş Yapın') : const Text('Hesabınız yok mu? Kayıt Olun'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
                child: const Text('Şifremi Unuttum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
