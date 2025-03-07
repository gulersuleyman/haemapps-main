import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/bloc/appointment_posts/appointment_posts_bloc.dart';
import 'package:user/models/appointment_post.dart';
import 'package:user/screens/appointmentPosts/widgets/appointment_card.dart';
import 'package:user/widgets/wave_dots.dart';

class AppointmentPostsScreen extends StatelessWidget {
  const AppointmentPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final geo = GetStorage().read('geo');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevular'),
      ),
      body: BlocBuilder<AppointmentPostsBloc, AppointmentPostsState>(
        builder: (context, appointmentPostsState) {
          if (appointmentPostsState is AppointmentPostsLoaded) {
            final appointmentPosts = appointmentPostsState.appointmentPosts;

            final Map<String, AppointmentPost> uniquePostsMap = {};

            for (final post in appointmentPosts) {
              if (!uniquePostsMap.containsKey(post.companyID)) {
                uniquePostsMap[post.companyID] = post;
              }
            }

            // Convert map values to list
            final uniquePosts = uniquePostsMap.values.toList();

            if (uniquePosts.isEmpty) {
              return const Center(child: Text('Randevu bulunamadı.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .62,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: uniquePosts.length,
                itemBuilder: (context, index) {
                  final post = uniquePosts[index];
                  final sameCompanyPosts = appointmentPosts.where((p) => p.companyID == post.companyID).toList();

                  return AppointmentCard(
                    appointmentPost: post,
                    geo: geo,
                    allAppointmentPostsFromCompany: sameCompanyPosts,
                  );
                },
              ),
            );
          }

          return const Center(child: WaveDots());
        },
      ),
    );
  }
}
