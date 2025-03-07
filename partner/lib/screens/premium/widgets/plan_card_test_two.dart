import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';

class PlanCardTestTwo extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final String? savingPercent;

  const PlanCardTestTwo({
    super.key,
    required this.selected,
    this.onTap,
    this.savingPercent,
  });

  @override
  Widget build(BuildContext context) {
    String periodText;
    String perMonthPrice;
    bool isAnnual = false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            context.mediumGap,
            Container(
              width: 25,
              height: 25,
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: context.theme.colorScheme.surfaceTint,
              ),
              child: Center(
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: selected ? context.theme.colorScheme.primary : Colors.transparent,
                  ),
                ),
              ),
            ),
            context.mediumGap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Yıllık Plan',
                  style: context.theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₺899.99/Yıl',
                  style: context.theme.textTheme.labelMedium,
                ),
              ],
            ),
            const Spacer(),
            if (savingPercent != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                height: 30,
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: isAnnual ? Colors.redAccent : Colors.yellow.shade900,
                ),
                child: Center(
                  child: Text(
                    '%$savingPercent indirim',
                    style: context.theme.textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            context.smallGap,
          ],
        ),
      ),
    );
  }
}
