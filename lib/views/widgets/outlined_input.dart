import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final Function(String? value)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final bool obscureText;
  final String? initialValue;
  final String? error;

  const OutlinedInput(
      {super.key,
      required this.label,
      this.controller,
      this.onChanged,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.placeholder = '',
      this.obscureText = false,
      this.inputFormatters = const [],
      this.initialValue,
      this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          onChanged: onChanged,
          controller: controller,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          keyboardType: keyboardType ?? TextInputType.text,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              errorText: error,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: placeholder),
        ),
      ],
    );
  }
}
