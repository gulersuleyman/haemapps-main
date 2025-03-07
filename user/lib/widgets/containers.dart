import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/material.dart';

class EpiContainer extends Container {
  final EdgeInsetsGeometry? customPadding;
  final EdgeInsetsGeometry? customMargin;
  final double? width;
  final double? height;
  final Color? customColor;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? customChild;
  final BorderRadiusGeometry? borderRadius;
  final bool shadow;
  final BoxShadow? boxShadow;
  final List<Color>? colors;
  EpiContainer({
    super.key,
    this.customPadding,
    this.customMargin,
    this.width,
    this.height,
    this.customColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.customChild,
    this.shadow = true,
    this.boxShadow,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: customPadding,
      margin: customMargin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: colors != null
            ? LinearGradient(
                colors: colors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: customColor ?? context.theme.colorScheme.surface,
        border: borderColor == null ? null : Border.all(color: borderColor!, width: borderWidth ?? 1),
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        boxShadow: shadow
            ? [
                boxShadow ??
                    BoxShadow(
                      color: context.theme.colorScheme.shadow,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
              ]
            : null,
      ),
      child: customChild,
    );
  }

  factory EpiContainer.rounded({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? color,
    Widget? child,
    Color? borderColor,
    double? borderWidth,
    bool? shadow,
    BoxShadow? boxShadow,
    List<Color>? colors,
  }) {
    return EpiContainer(
      customPadding: padding,
      height: height,
      width: width,
      customColor: color,
      customMargin: margin,
      borderRadius: BorderRadius.circular(16),
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadow: shadow ?? false,
      boxShadow: boxShadow,
      colors: colors,
      customChild: child,
    );
  }
}
