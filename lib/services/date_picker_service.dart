import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerService {
  static Future<void> selectDate({
    required BuildContext context,
    required TextEditingController controller,
    DateTime? initialDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale("pt", "BR"),
    );

    if (picked != null) {
      // Atualiza o campo com a data formatada
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
}