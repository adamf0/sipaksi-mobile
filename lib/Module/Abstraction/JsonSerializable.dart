abstract class JsonSerializable {
  Map<String, dynamic> toJson();
  static JsonSerializable fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
