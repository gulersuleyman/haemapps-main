import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SearchCard extends StatelessWidget {
  final TextEditingController controller;

  const SearchCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? geo = GetStorage().read('geo');

    if (geo == null || geo.isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.scrim,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.shadow,
            blurRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Arama yap',
          hintStyle: context.theme.textTheme.labelLarge,
          suffixIcon: IconButton(
            icon: controller.text.isEmpty ? const Icon(Icons.search) : const Icon(Icons.close),
            onPressed: () {
              controller.clear();
              FocusScope.of(context).unfocus();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
