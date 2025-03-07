// /// TODO:(Emre): This screen is no longer needed.

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:models/models.dart';
// import 'package:user/campaign/campaign_bloc.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   late Map<String, dynamic>? geo;
//   late CameraPosition? initialCameraPosition;

//   @override
//   void initState() {
//     super.initState();
//     geo = GetStorage().read('geo');
//     if (geo != null) {
//       initialCameraPosition = CameraPosition(
//         target: LatLng(geo!['lat'], geo!['lon']),
//         zoom: 14.4746,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.future.then((controller) => controller.dispose());
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (geo == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text('Location data not found'),
//         ),
//       );
//     }

//     return Scaffold(
//       body: BlocBuilder<CampaignBloc, CampaignState>(
//         builder: (context, state) {
//           if (state is CampaignsLoaded) {
//             final List<Campaign> campaigns = state.campaigns;

//             // Generate markers from campaigns list
//             final Set<Marker> markers = campaigns.map((campaign) {
//               return Marker(
//                 markerId: MarkerId(campaign.id),
//                 position: LatLng(campaign.geo['geopoint'].latitude, campaign.geo['geopoint'].longitude),
//                 infoWindow: InfoWindow(
//                   title: campaign.title,
//                   snippet: campaign.description,
//                 ),
//               );
//             }).toSet();

//             return GoogleMap(
//               initialCameraPosition: initialCameraPosition!,
//               markers: markers,
//               onMapCreated: _controller.complete,
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
