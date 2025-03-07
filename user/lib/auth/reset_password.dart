import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_http/epi_http.dart';
import 'package:flutter/material.dart';
import 'package:user/widgets/epi_text_field.dart';
import 'package:user/widgets/wave_dots.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 500,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (isDone)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xffFF9100),
                        size: 40,
                      ),
                      context.mediumGap,
                      Text(
                        'Şifre sıfırlama e-postası gönderildi. Lütfen e-postanızı kontrol edin.',
                        style: context.theme.textTheme.titleMedium!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffFF9100),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Text(
                      'Şifre Sıfırla',
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffFF9100),
                      ),
                    ),
                    context.largeGap,
                    SizedBox(
                      height: 65,
                      child: EpiTextField(
                        height: 60,
                        placeholder: 'E-posta',
                        controller: emailController,
                      ),
                    ),
                    context.mediumGap,
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: IgnorePointer(
                        ignoring: loading,
                        child: FilledButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffFF9100)),
                          ),
                          onPressed: () async {
                            if (emailController.text.isEmpty) {
                              return;
                            }

                            setState(() => loading = true);

                            final result = await EpiFirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text,
                            );

                            if (result.status == Status.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Şifre sıfırlama e-postası gönderildi.'),
                                ),
                              );

                              setState(() {
                                isDone = true;
                                loading = false;
                              });
                            } else {
                              setState(() => loading = false);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result.message ?? 'Bir hata oluştu'),
                                ),
                              );
                            }
                          },
                          child: loading
                              ? const Center(
                                  child: WaveDots(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Gönder', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FsFirebaseAuth {}

class RestoTextField {}
