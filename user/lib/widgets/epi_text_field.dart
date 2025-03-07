import 'package:epi_extensions/epi_extensions.dart';
import 'package:flutter/cupertino.dart';

class EpiTextField extends StatelessWidget {
  final String? title;
  final String placeholder;
  final int? maxLength;
  final int? maxLines;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool hasError;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool enabled;
  final double? height;

  const EpiTextField({
    super.key,
    this.title,
    required this.placeholder,
    this.maxLength,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.hasError = false,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              color: hasError ? context.theme.colorScheme.error : null,
            ),
          ),
        context.tinyGap,
        SizedBox(
          height: height,
          child: CupertinoTextField(
            enabled: enabled,
            obscureText: obscureText,
            readOnly: readOnly,
            onTap: onTap,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: hasError ? context.theme.colorScheme.error : context.theme.colorScheme.surfaceContainer,
              ),
            ),
            maxLines: maxLines ?? 1,
            controller: controller,
            padding: context.smallPadding,
            placeholder: placeholder,
            style: context.theme.textTheme.bodyLarge,
            keyboardType: keyboardType,
            maxLength: maxLength,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ],
    );
  }
}
