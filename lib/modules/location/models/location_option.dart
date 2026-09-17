/// One entry in a state, district or taluka dropdown.
class LocationOption {
  const LocationOption({required this.code, required this.name});

  factory LocationOption.fromJson(Map<String, dynamic> json) {
    return LocationOption(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  final String code;
  final String name;
}
