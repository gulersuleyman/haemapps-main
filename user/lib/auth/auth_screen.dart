import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:models/models.dart';
import 'package:user/auth/partner_auth_screen.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingTransparencyRequest();
      if ((GetStorage().read('signedOutFromUser') ?? false) == true) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PartnerAuthScreen(),
            ),
          );
        }
      }
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
      body: Padding(
        padding: context.mediumPadding,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  'Hem',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ),
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
              context.smallGap,
              SizedBox(
                height: 55,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email ve Şifre alanları boş olamaz.')));
                        return;
                      }

                      setState(() => isLoading = true);
                      await GetStorage().write('accountType', 'user');
                      await GetStorage().remove('signedOutFromUser');

                      final response = await EpiFirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      if (response.status != Status.success) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message ?? 'Bir hata oluştu.')));
                        setState(() => isLoading = false);
                      }
                    },
                    child: isLoading
                        ? const Center(child: WaveDots(color: Colors.white))
                        : const Text('Giriş Yap', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const Spacer(),
              context.smallGap,
              SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await GetStorage().write('accountType', 'user');
                    final EpiResponse<UserCredential?> result = await EpiFirebaseAuth.instance.signInAnonymously();

                    if (result.status == Status.success) {
                      final UserCredential credential = result.data!;

                      try {
                        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(
                              AppUser(
                                email: 'anonymous',
                                favorites: const [],
                              ).toMap(),
                            );

                        await GetStorage().remove('signedOutFromUser');
                      } on FirebaseException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message ?? 'An error occurred'),
                          ),
                        );
                        setState(() => isLoading = false);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('An error occurred'),
                          ),
                        );
                        setState(() => isLoading = false);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message ?? 'An error occurred'),
                        ),
                      );
                      setState(() => isLoading = false);
                    }
                  },
                  child: isLoading
                      ? const Center(child: WaveDots(color: Colors.white))
                      : const Text(
                          'Giriş Yapmadan Devam Et',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
