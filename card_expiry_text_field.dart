import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardExpiryTextField extends StatelessWidget {
  final TextEditingController controller;

  CardExpiryTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Card Expiry',
        hintText: 'MM/YY',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      inputFormatters: [
        // Use input formatters to format the input as MM/YY
        LengthLimitingTextInputFormatter(5),
        FilteringTextInputFormatter.digitsOnly,
        CardExpiryInputFormatter(), // Custom input formatter
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Card expiry is required';
        }
        // Additional validation logic can be added here
        return null;
      },
    );
  }
}

class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (text.length > 5) {
      return oldValue; // Prevent input if length exceeds 5 characters
    }
    var formatted = '';
    for (var i = 0; i < text.length; i++) {
      formatted += text[i];
      if (i == 1) {
        formatted += '/'; // Add slash after two characters
      }
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
