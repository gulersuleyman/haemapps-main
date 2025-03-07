import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/models/appointment.dart';
import 'package:user/models/appointment_post.dart';
import 'package:user/partner_bloc/appointment/appointments_bloc.dart';
import 'package:user/partner_bloc/appointment_post/appointment_post_bloc.dart';
import 'package:user/partner_screens/appointments/create_appointment_post.dart';
import 'package:user/widgets/wave_dots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool isAppointmentsSelected = false;

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final appointmentDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dayText = '';
    if (appointmentDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      dayText = 'Bugün';
    } else if (appointmentDate.isAtSameMomentAs(tomorrow)) {
      dayText = 'Yarın';
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$dayText $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevular'),
      ),
      floatingActionButton: isAppointmentsSelected
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateAppointment(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isAppointmentsSelected ? context.theme.colorScheme.primary : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isAppointmentsSelected = false;
                      });
                    },
                    child: const Text(
                      'Randevu Talepleri',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAppointmentsSelected ? context.theme.colorScheme.primary : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isAppointmentsSelected = true;
                      });
                    },
                    child: const Text(
                      'Uygun Saatler',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AppointmentPostBloc, AppointmentPostState>(
              builder: (context, appointmentPostsState) {
                return BlocBuilder<AppointmentsBloc, AppointmentsState>(
                  builder: (context, appointmentsState) {
                    if (appointmentsState is AppointmentsLoaded && appointmentPostsState is AppointmentPostLoaded) {
                      final List<AppointmentPost> appointmentPosts = appointmentPostsState.appointmentPosts;
                      final List<Appointment> appointments = appointmentsState.appointments;

                      if (isAppointmentsSelected) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: appointmentPosts.length,
                          itemBuilder: (context, index) {
                            final post = appointmentPosts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Handle tap
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      if (post.companyImage != null)
                                        Container(
                                          width: 60,
                                          height: 60,
                                          margin: const EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: NetworkImage(post.companyImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    post.companyName,
                                                    style: TextStyle(
                                                      color: context.theme.colorScheme.primary,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () async {
                                                    final shouldDelete = await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Randevuyu Sil'),
                                                        content: const Text('Bu randevu saatini silmek istediğinizden emin misiniz?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: const Text('İptal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: Text(
                                                              'Sil',
                                                              style: TextStyle(
                                                                color: context.theme.colorScheme.error,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (shouldDelete == true) {
                                                      await FirebaseFirestore.instance.collection('appointmentPosts').doc(post.id).delete();
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: context.theme.colorScheme.error,
                                                  ),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 20,
                                                  ),
                                                  label: const Text('Sil'),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  size: 20,
                                                  color: context.theme.colorScheme.secondary,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _formatDateTime(post.start.toDate()),
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  Icons.people,
                                                  size: 20,
                                                  color: context.theme.colorScheme.secondary,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${post.personCount} kişi',
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: context.theme.colorScheme.primary.withOpacity(0.1),
                                          child: Text(
                                            appointment.userName.substring(0, 1).toUpperCase(),
                                            style: TextStyle(
                                              color: context.theme.colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                appointment.userName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                appointment.userEmail,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            final Uri phoneUri = Uri(
                                              scheme: 'tel',
                                              path: appointment.userPhone,
                                            );
                                            launchUrl(phoneUri);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: context.theme.colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                          icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                                          label: const Text('Müşteriyi Ara', style: TextStyle(color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: context.theme.colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: context.theme.colorScheme.primary,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDateTime(appointment.post['start'].toDate()),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 40,
                                            width: 1,
                                            color: Colors.grey[300],
                                          ),
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                color: context.theme.colorScheme.primary,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${appointment.peopleCount} Kişi',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (appointment.note != null && appointment.note!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.note,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                appointment.note!,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return const Center(child: WaveDots());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
