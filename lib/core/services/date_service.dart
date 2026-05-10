import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateService {
  /// Shows a date picker and returns the selected DateTime or null if canceled.
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
  }

  /// Shows a date picker and returns the formatted date string or null if canceled.
  static Future<String?> pickFormatDate(BuildContext context) async {
    final picked = await pickDate(context, initialDate: DateTime.now());
    if (picked == null) return null;
    return formatDate(picked);
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  static String formatStringDate(String date) {
    final normalizedDate = date.trim();
    if (normalizedDate.isEmpty) return '-';

    final parsedDate = DateTime.tryParse(normalizedDate);
    if (parsedDate == null) return '-';

    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(parsedDate);
  }

  static String formatEmployeeDate({required String date}) {
    final normalizedDate = date.trim();
    if (normalizedDate.isEmpty) return '-';

    DateTime? parsedDate = DateTime.tryParse(normalizedDate);
    if (parsedDate == null) {
      try {
        parsedDate = DateFormat('dd-MM-yyyy').parseStrict(normalizedDate);
      } catch (_) {}
    }
    if (parsedDate == null) {
      try {
        parsedDate = DateFormat('dd/MM/yyyy').parseStrict(normalizedDate);
      } catch (_) {}
    }
    if (parsedDate == null) return '-';

    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(parsedDate);
  }

  static String formatOrderDate({required String date}) {
    final normalizedDate = date.trim();
    if (normalizedDate.isEmpty) return '-';

    final parsedDate = DateTime.tryParse(normalizedDate);
    if (parsedDate == null) return '-';

    final now = DateTime.now();
    final difference = now.difference(parsedDate);

    if (difference.isNegative) return 'الآن';

    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) return '${difference.inMinutes}د';
    if (difference.inHours < 24) return '${difference.inHours}س';
    if (difference.inDays < 30) return '${difference.inDays}ي';

    final months = (difference.inDays / 30).floor();
    if (months < 12) return '$monthsش';

    final years = (difference.inDays / 365).floor();
    return '$yearsسن';
  }
}
