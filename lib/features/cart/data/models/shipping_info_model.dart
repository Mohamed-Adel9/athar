import 'package:flutter/material.dart';

@immutable
class ShippingInfoModel {
  const ShippingInfoModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.address = '',
    this.city = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String city;

  bool get isComplete =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      city.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
      'city': city,
    };
  }

  ShippingInfoModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
  }) {
    return ShippingInfoModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingInfoModel &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          phone == other.phone &&
          address == other.address &&
          city == other.city;

  @override
  int get hashCode => Object.hash(firstName, lastName, phone, address, city);
}
