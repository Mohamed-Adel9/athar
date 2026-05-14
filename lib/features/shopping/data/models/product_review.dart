
import 'package:flutter/material.dart';

@immutable
class ProductReview {
  const ProductReview({
    required this.userName,
    required this.userImage,
    required this.date,
    required this.rating,
    required this.comment,
  });

  final String userName;
  final String userImage;
  final String date;
  final double rating;
  final String comment;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductReview && runtimeType == other.runtimeType && userName == other.userName && date == other.date;

  @override
  int get hashCode => Object.hash(userName, date);
}