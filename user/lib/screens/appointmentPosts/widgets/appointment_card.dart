import 'package:cached_network_image/cached_network_image.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:user/models/appointment_post.dart';
import 'package:user/screens/appointmentPosts/widgets/appointment_details.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentPost appointmentPost;
  final List<AppointmentPost> allAppointmentPostsFromCompany;
  final Map<String, dynamic> geo;

  const AppointmentCard({
    super.key,
    required this.appointmentPost,
    required this.geo,
    required this.allAppointmentPostsFromCompany,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetails(
              allAppointmentPostsFromCompany: allAppointmentPostsFromCompany,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: appointmentPost.id,
            child: Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: context.theme.colorScheme.surfaceContainer,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            appointmentPost.companyImage ?? 'https://fakeimg.pl/600x400?text=image&font=bebas',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointmentPost.companyName.capitalize,
                  style: context.theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                context.tinyGap,
                Text(
                  appointmentPost.category,
                  style: context.theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.tinyGap,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
