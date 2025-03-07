import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:user/models/appointment_post.dart';
import 'package:user/partner_bloc/appointment_post/appointment_post_bloc.dart';
import 'package:user/partner_bloc/bloc_extensions.dart';
import 'package:user/partner_bloc/partner/partner_bloc.dart';
import 'package:user/partner_screens/create/empty_time_picker.dart';
import 'package:user/services/location.dart';
import 'package:user/widgets/wave_dots.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:models/models.dart';

class CreateAppointment extends StatefulWidget {
  const CreateAppointment({super.key});

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  bool isLoading = false;
  bool isToday = true;
  TimeOfDay? startTime;
  int personCount = 1;

  DateTime get selectedDate {
    final now = DateTime.now();
    if (isToday) {
      return now;
    } else {
      return now.add(const Duration(days: 1));
    }
  }

  bool hasAppointmentInSameHour(List<AppointmentPost> appointments, DateTime newAppointmentTime) {
    return appointments.any((appointment) {
      final appointmentDateTime = appointment.start.toDate();
      return appointmentDateTime.year == newAppointmentTime.year &&
          appointmentDateTime.month == newAppointmentTime.month &&
          appointmentDateTime.day == newAppointmentTime.day &&
          appointmentDateTime.hour == newAppointmentTime.hour;
    });
  }

  AppointmentPost? getExistingAppointment(List<AppointmentPost> appointments, DateTime newAppointmentTime) {
    try {
      return appointments.firstWhere(
        (appointment) {
          final appointmentDateTime = appointment.start.toDate();
          return appointmentDateTime.year == newAppointmentTime.year &&
              appointmentDateTime.month == newAppointmentTime.month &&
              appointmentDateTime.day == newAppointmentTime.day &&
              appointmentDateTime.hour == newAppointmentTime.hour;
        },
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müsait Vakit Oluştur'),
        actions: [
          IgnorePointer(
            ignoring: isLoading,
            child: TextButton.icon(
              onPressed: onSubmit,
              label: Text(isLoading ? '' : 'Kaydet'),
              icon: isLoading ? const WaveDots() : const Icon(Icons.save),
            ),
          ),
        ],
      ),
      body: BlocBuilder<PartnerBloc, PartnerState>(
        builder: (context, state) {
          if (state is PartnerLoaded) {
            return ListView(
              padding: context.mediumPadding,
              children: [
                Text(
                  'Tarih:',
                  style: context.theme.textTheme.titleMedium,
                ),
                context.smallGap,
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Bugün'),
                      selected: isToday,
                      onSelected: isLoading
                          ? null
                          : (bool selected) {
                              if (selected) {
                                setState(() {
                                  isToday = true;
                                });
                              }
                            },
                    ),
                    ChoiceChip(
                      label: const Text('Yarın'),
                      selected: !isToday,
                      onSelected: isLoading
                          ? null
                          : (bool selected) {
                              if (selected) {
                                setState(() {
                                  isToday = false;
                                });
                              }
                            },
                    ),
                  ],
                ),
                context.smallGap,
                CustomTimeInput(
                  title: 'Saat:',
                  placeholder: 'Saat Seç',
                  isLoading: isLoading,
                  onTimeSelected: (TimeOfDay? time) {
                    if (time != null) {
                      startTime = time;
                    }
                  },
                ),
                context.smallGap,
                Text(
                  'Kişi Sayısı:',
                  style: context.theme.textTheme.titleMedium,
                ),
                context.smallGap,
                Row(
                  children: [
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (personCount > 1) {
                                setState(() {
                                  personCount--;
                                });
                              }
                            },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      personCount.toString(),
                      style: context.theme.textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                personCount++;
                              });
                            },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> onSubmit() async {
    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen saat seçiniz.')),
      );
      return;
    }

    final DateTime combinedStartDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime!.hour,
      startTime!.minute,
    );

    final state = context.read<AppointmentPostBloc>().state;
    if (state is AppointmentPostLoaded) {
      final existingAppointment = getExistingAppointment(state.appointmentPosts, combinedStartDateTime);
      if (existingAppointment != null) {
        final existingTime = existingAppointment.start.toDate();
        final String timeString = '${existingTime.hour.toString().padLeft(2, '0')}.${existingTime.minute.toString().padLeft(2, '0')}';

        final bool? shouldContinue = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Dikkat'),
              content: Text("$timeString'da bir randevunuz bulunmaktadır. Yine de oluşturmak istiyor musunuz?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Vazgeç'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Oluştur'),
                ),
              ],
            );
          },
        );

        if (shouldContinue != true) {
          return;
        }
      }
    }

    setState(() => isLoading = true);

    final Map<String, dynamic>? geo = GetStorage().read('geo');

    if (geo == null) {
      await LocationService.instance.getLocation();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konum bilgisi alınamadı.')),
      );
      setState(() => isLoading = false);
      return;
    }

    final lat = geo['lat'];
    final lan = geo['lon'];

    final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(lat, lan));
    final PartnerUser? partnerUser = context.getPartnerUser;

    if (partnerUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı bilgisi alınamadı.')),
      );
      setState(() => isLoading = false);
      return;
    }

    await FirebaseFirestore.instance.collection('appointmentPosts').add({
      'title': '',
      'companyName': partnerUser.name,
      'companyID': EpiFirebaseAuth.instance.currentUser!.uid,
      'companyImage': null,
      'start': Timestamp.fromDate(combinedStartDateTime),
      'geo': geoFirePoint.data,
      'isVisible': true,
      'category': partnerUser.category ?? '',
      'personCount': personCount,
    });

    context.pop();
  }
}
