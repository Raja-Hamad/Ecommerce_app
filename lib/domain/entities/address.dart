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
  final bool isDefault;

  String get fullAddress => '$addressLine, $city, $state $zipCode';

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
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
