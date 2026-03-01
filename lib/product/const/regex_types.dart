import 'package:flutter/material.dart';

/// Regex patterns used throughout the application.
/// For form validation and input formatting.
@immutable
final class RegexTypes {
  const RegexTypes._();

  /// Full Name — supports Turkish characters, at least 2+2 letters.
  static final RegExp fullName = RegExp(
    r'^[a-zA-ZçÇğĞıİöÖşŞüÜ]{2,}\s[a-zA-ZçÇğĞıİöÖşŞüÜ]{2,}$',
  );

  /// Email address.
  static final RegExp email = RegExp(
    r'^[\w.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Student email (.edu extension).
  static final RegExp studentEmail = RegExp(
    r'^[\w.-]+@[a-zA-Z0-9.-]+\.(edu|edu\.[a-zA-Z]{2,})$',
  );

  /// Digits only — for phone number formatting.
  static final RegExp digitsOnly = RegExp('[^0-9]');

  /// Phone number — +90 5xx xxx xx xx format.
  static final RegExp phoneNumber = RegExp(
    r'^\+?[0-9]{10,13}$',
  );

  /// Password — at least 8 characters, 1 letter + 1 digit.
  static final RegExp password = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d).{8,}$',
  );
}
