/// A saved delivery address.
class AddressModel {
  const AddressModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.line1,
    this.line2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.isDefault = false,
  });

  final int id;
  final String name;
  final String mobile;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    String text(String key) {
      final value = json[key]?.toString().trim() ?? '';
      return value == 'null' ? '' : value;
    }

    final isDefault = json['is_default'];

    return AddressModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: text('name'),
      mobile: text('mobile'),
      line1: text('address_line1'),
      line2: text('address_line2'),
      city: text('city'),
      state: text('state'),
      pincode: text('pincode'),
      isDefault: isDefault == true || isDefault == 1 || isDefault == '1',
    );
  }

  /// e.g. "Ramesh – Pune 411001".
  String get shortLabel => '$name – ${[city, pincode].where((part) => part.isNotEmpty).join(' ')}';

  String get fullAddress => [line1, line2, city, state, pincode].where((part) => part.isNotEmpty).join(', ');
}
