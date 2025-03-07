import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user/widgets/epi_text_field.dart';

class CustomTimeInput extends StatefulWidget {
  final String title;
  final String placeholder;
  final bool isLoading;
  final void Function(TimeOfDay?) onTimeSelected;

  const CustomTimeInput({
    Key? key,
    required this.title,
    required this.placeholder,
    this.isLoading = false,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<CustomTimeInput> createState() => _CustomTimeInputState();
}

class _CustomTimeInputState extends State<CustomTimeInput> {
  final FocusNode hourFocusNode = FocusNode();
  final FocusNode minuteFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void _showCustomTimePicker() {
    if (widget.isLoading) return;

    // Start with empty controllers
    final hourController = TextEditingController();
    final minuteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saat Seç'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Hour input
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: hourFocusNode,
                      controller: hourController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Saat',
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 2) {
                          FocusScope.of(context).requestFocus(minuteFocusNode);
                        }
                      },
                    ),
                  ),
                  const Text(' : '),
                  // Minute input
                  Expanded(
                    child: TextField(
                      focusNode: minuteFocusNode,
                      controller: minuteController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Dakika',
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                final hour = int.tryParse(hourController.text) ?? 0;
                final minute = int.tryParse(minuteController.text) ?? 0;

                if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                  final time = TimeOfDay(hour: hour, minute: minute);
                  _controller.text = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                  widget.onTimeSelected(time);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Geçerli bir saat giriniz (00-23:00-59)')),
                  );
                }
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EpiTextField(
      controller: _controller,
      title: widget.title,
      placeholder: widget.placeholder,
      readOnly: true,
      onTap: _showCustomTimePicker,
    );
  }
}
