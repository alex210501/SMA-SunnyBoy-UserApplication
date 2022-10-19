/// Represent a single data from the SMA device
class SingleData<T> {
  T value;
  String unit;

  /// Constructor takes a [value] with a [unit]
  SingleData(this.value, this.unit);

  /// Construct an instance from JSON data
  SingleData.fromJson(Map<String, dynamic> jsonData)
      : value = jsonData['value'] ?? 0, unit = jsonData['unit'] ?? "";

  /// Return a JSON representation of the class
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'value': value,
      'unit': unit
    };
  }
}