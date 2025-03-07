import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:user/widgets/wave_dots.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late Map<String, dynamic> address = GetStorage().read('address');

  bool isLoading = false;

  void listenStorageChanges() {
    GetStorage().listenKey('address', (value) {
      setState(() {
        address = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    address = GetStorage().read('address') ?? {};
    listenStorageChanges();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? geo = GetStorage().read('geo');

    if (geo == null) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.scrim,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.shadow,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          context.largeGap,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${address['street']}, ${address['locality']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Adresiniz',
                style: context.theme.textTheme.labelLarge,
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              setState(() => isLoading = true);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => isLoading = false);
            },
            child: Container(
              height: 60,
              width: 71,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary.withOpacity(.4),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: isLoading
                    ? WaveDots(
                        color: context.theme.colorScheme.primary,
                      )
                    : Icon(
                        Icons.refresh,
                        color: context.theme.colorScheme.primary,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
