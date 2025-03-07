import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:models/models.dart';
import 'package:user/auth/reset_password.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';

class PartnerAuthScreen extends StatefulWidget {
  const PartnerAuthScreen({super.key});

  @override
  State<PartnerAuthScreen> createState() => _PartnerAuthScreenState();
}

class _PartnerAuthScreenState extends State<PartnerAuthScreen> {
  bool isLoading = false;
  bool isRegister = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

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
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 500,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Haem Partner',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFF9100),
                  ),
                ),
              ),
              Center(
                child: Text(
                  isRegister ? 'Kayıt Ol' : 'Giriş Yap',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFF9100),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EpiTextField(
                    height: 60,
                    controller: emailController,
                    placeholder: 'E-posta',
                  ),
                ),
              ),
              SizedBox(
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EpiTextField(
                    height: 60,
                    controller: passwordController,
                    placeholder: 'Şifre',
                    obscureText: true,
                  ),
                ),
              ),
              if (isRegister)
                SizedBox(
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: EpiTextField(
                      height: 60,
                      controller: passwordAgainController,
                      placeholder: 'Şifre (Tekrar)',
                      obscureText: true,
                    ),
                  ),
                ),
              context.mediumGap,
              SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffFF9100)),
                    ),
                    onPressed: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email ve Şifre alanları boş olamaz.')));
                        return;
                      }

                      if (isRegister && passwordController.text != passwordAgainController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şifreler uyuşmuyor.')));
                        return;
                      }

                      setState(() => isLoading = true);
                      await GetStorage().write('accountType', 'partner');

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
                          await GetStorage().remove('signedOutFromUser');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? 'Bir hata oluştu.')));
                          setState(() => isLoading = false);
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
                            ? const Text('Kayıt Ol', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
                            : const Text('Giriş Yap', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              context.mediumGap,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isRegister = !isRegister;
                    });
                  },
                  child: isRegister
                      ? const Text(
                          'Hesabınız var mı? Giriş Yapın',
                          style: TextStyle(
                            color: Color(0xffFF9100),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : const Text(
                          'Hesabınız yok mu? Kayıt Olun',
                          style: TextStyle(
                            color: Color(0xffFF9100),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
                child: Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                    color: context.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
