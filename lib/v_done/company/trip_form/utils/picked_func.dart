
  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> selectDate({
    required BuildContext context,
    required TextEditingController dateController,
    selectedDate,
    firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: DateTime((DateTime.now().year) + 3, 12),
        errorInvalidText: "Out of range");
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    }
  }

  Future<void> selectTime(
      {required BuildContext context,
      required TextEditingController timeController}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    formatTime(pickedTime, context, timeController);
  }

  void formatTime(TimeOfDay? pickedTime, BuildContext context, TextEditingController timeController) {
    if (pickedTime != null) {
      DateTime parsedTime =
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      DateFormat('HH:mm').format(parsedTime);
      timeController.text = pickedTime.format(context);
    }
  }
