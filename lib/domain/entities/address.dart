class Address {
  const Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  String get fullAddress => '$addressLine, $city, $state $zipCode, $country';

  factory Address.fromJson(Map<String, dynamic> json) {
    final line2 = json['addressLine2'] as String? ?? '';
    final line1 = json['addressLine1'] as String? ?? '';
    return Address(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      label: json['label'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phoneNumber'] as String? ?? '',
      addressLine: line2.isNotEmpty ? '$line1, $line2' : line1,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Address copyWith({bool? isDefault}) {
    return Address(
      id: id,
      label: label,
      fullName: fullName,
      phone: phone,
      addressLine: addressLine,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
