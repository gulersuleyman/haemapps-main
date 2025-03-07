import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partner/widgets/containers.dart';

class EpiListTile extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final Color leadingColor;
  final VoidCallback? onTap;
  final Widget? customTrailing;
  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;

  const EpiListTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.leadingColor = Colors.black,
    this.onTap,
    this.customTrailing,
    this.iconSize,
    this.iconPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CupertinoListTile(
        backgroundColor: context.theme.colorScheme.surfaceContainer,
        title: Text(
          title,
          style: context.theme.textTheme.titleMedium,
        ),
        leading: EpiContainer(
          customColor: leadingColor,
          customChild: Center(
            child: Padding(
              padding: iconPadding ?? EdgeInsets.zero,
              child: Icon(
                leadingIcon,
                color: Colors.white,
                size: iconSize ?? 20,
              ),
            ),
          ),
        ),
        trailing: customTrailing ??
            Icon(
              Icons.chevron_right,
              color: context.theme.colorScheme.primary,
            ),
      ),
    );
  }
}
