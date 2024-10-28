class RadioModel {
  bool isSelected;
  final String key;
  final String value;
  final dynamic rules;

  RadioModel({
    required this.isSelected,
    required this.key,
    required this.value,
    this.rules,
  });
}
