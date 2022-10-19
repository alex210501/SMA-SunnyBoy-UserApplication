/// Model for the local time of the SMA device
class SmaTime {
  int localTime;
  int offset;

  /// Constructor takes a [localTime] and an [offset]
  SmaTime(this.localTime, this.offset);

  /// Construct an instance from JSON data
  SmaTime.fromJson(Map<String, dynamic> jsonData)
      : localTime = jsonData['currentTime'] ?? 0, offset = jsonData['offset'] ?? 0;

  /// Return a JSON representation of the class
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currentTime': localTime,
      'offset': offset
    };
  }
}