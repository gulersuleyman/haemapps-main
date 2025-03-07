import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/bloc/user/user_bloc.dart';
import 'package:user/models/appointment_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_extensions/epi_extensions.dart';

class AppointmentDetails extends StatelessWidget {
  final List<AppointmentPost> allAppointmentPostsFromCompany;

  const AppointmentDetails({
    super.key,
    required this.allAppointmentPostsFromCompany,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final appointmentDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dayText;
    if (appointmentDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      dayText = 'Bugün';
    } else if (appointmentDate.isAtSameMomentAs(tomorrow)) {
      dayText = 'Yarın';
    } else {
      dayText = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$dayText $hour:$minute';
  }

  Future<void> _showBookingDialog(BuildContext context, AppointmentPost post) async {
    int selectedCount = 1;

    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kişi Sayısı Seçin (Maksimum ${post.personCount})',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedCount > 1 ? () => setState(() => selectedCount--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        selectedCount.toString(),
                        style: context.theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: selectedCount < post.personCount ? () => setState(() => selectedCount++) : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, selectedCount),
                    child: const Text('Randevu Oluştur'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      final user = EpiFirebaseAuth.instance.currentUser;
      if (user == null || user.isAnonymous) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hesap Gerekli'),
            content: const Text('Anonim hesaplar ile randevu oluşturulamaz. Lütfen önce profil sayfasından hesap oluşturun.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
        return;
      }

      final userBloc = context.read<UserBloc>().state as UserLoaded;

      try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'post': post.toMap(),
          'userID': user.uid,
          'userName': userBloc.user.name ?? '',
          'userPhone': userBloc.user.phone ?? '',
          'userEmail': user.email ?? '',
          'peopleCount': result,
          'createdAt': Timestamp.now(),
          'companyID': post.companyID,
        });

        final newPersonCount = post.personCount - result;

        if (newPersonCount == 0) {
          await FirebaseFirestore.instance.collection('appointmentPosts').doc(post.id).delete();
        } else {
          await FirebaseFirestore.instance.collection('appointmentPosts').doc(post.id).update({
            'personCount': newPersonCount,
          });
        }

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Randevu Oluşturuldu'),
            content: const Text('Randevunuz oluşturuldu. Lütfen randevu saatinden en az 10 dakika önce randevu yerinde olun.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bir hata oluştu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allAppointmentPostsFromCompany.first.companyName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allAppointmentPostsFromCompany.length,
        itemBuilder: (context, index) {
          final post = allAppointmentPostsFromCompany[index];
          final dateTime = post.start.toDate();

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title.isEmpty ? 'Randevu' : post.title,
                    style: context.theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDateTime(dateTime),
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.personCount} kişi'),
                  ],
                ),
              ),
              trailing: post.personCount > 0
                  ? FilledButton(
                      onPressed: () => _showBookingDialog(context, post),
                      child: const Text('Randevu Al'),
                    )
                  : const TextButton(
                      onPressed: null,
                      child: Text('Dolu'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
