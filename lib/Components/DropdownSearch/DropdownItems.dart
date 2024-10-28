class DropdownItems {
  final String key;
  final String text;
  final dynamic extra;

  DropdownItems({
    required this.key,
    required this.text,
    required this.extra,
  });

  // Update the factory method to handle a single item
  factory DropdownItems.fromJson(Map<String, dynamic> json) => DropdownItems(
        key: json["id"],
        text: json["name"],
        extra: json,
      );

  // Create a method to handle a list of JSON objects
  static List<DropdownItems> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => DropdownItems.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        "key": key,
        "text": text,
        "extra": extra,
      };
}
