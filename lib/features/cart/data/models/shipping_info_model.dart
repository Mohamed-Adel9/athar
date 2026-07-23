import 'package:flutter/material.dart';

@immutable
class ShippingInfoModel {
  const ShippingInfoModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.postalCode = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String city;
  final String postalCode;

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
      'postal_code': postalCode,
    };
  }

  ShippingInfoModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
  }) {
    return ShippingInfoModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
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
          city == other.city &&
          postalCode == other.postalCode;

  @override
  int get hashCode =>
      Object.hash(firstName, lastName, phone, address, city, postalCode);
}
