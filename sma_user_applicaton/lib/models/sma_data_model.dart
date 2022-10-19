import 'single_data_model.dart';
import 'sma_time_model.dart';

/// Model for the SMA data received from getValues()
class SmaData {
  final SingleData power;
  final SingleData energyToday;
  final SingleData energyTotal;
  final SingleData l1Power;
  final SingleData l1Voltage;
  final SingleData l1Current;
  final SingleData frequency;
  final SingleData dcPower;
  final SingleData dcVoltage;
  final SingleData dcCurrent;
  final SingleData operatingTime;
  final SingleData ethernetIp;
  final SingleData wlanIp;
  final SmaTime time;

  /// Constructor to pass [power], [energyToday], [energyTotal], [l1Power],
  /// [l1Voltage], [l1Current], [frequency], [dcPower], [dcVoltage],
  /// [dcCurrent], [operatingTime], [ethernetIp], [wlanIp], [time]
  SmaData(
      this.power,
      this.energyToday,
      this.energyTotal,
      this.l1Power,
      this.l1Voltage,
      this.l1Current,
      this.frequency,
      this.dcPower,
      this.dcVoltage,
      this.dcCurrent,
      this.operatingTime,
      this.ethernetIp,
      this.wlanIp,
      this.time);

  /// Construct an instance from JSON data
  SmaData.fromJson(Map<String, dynamic> jsonData)
      : power = SingleData.fromJson(jsonData['power'] ?? {}),
        energyToday = SingleData.fromJson(jsonData['energy_today'] ?? {}),
        energyTotal = SingleData.fromJson(jsonData['energy_total'] ?? {}),
        l1Power = SingleData.fromJson(jsonData['L1_power'] ?? {}),
        l1Voltage = SingleData.fromJson(jsonData['L1_voltage'] ?? {}),
        l1Current = SingleData.fromJson(jsonData['L1_current'] ?? {}),
        frequency = SingleData.fromJson(jsonData['frequency'] ?? {}),
        dcPower = SingleData.fromJson(jsonData['dc_power'] ?? {}),
        dcVoltage = SingleData.fromJson(jsonData['dc_voltage'] ?? {}),
        dcCurrent = SingleData.fromJson(jsonData['dc_current'] ?? {}),
        operatingTime = SingleData.fromJson(jsonData['operating_time'] ?? {}),
        ethernetIp = SingleData.fromJson(jsonData['ethernet_ip'] ?? {}),
        wlanIp = SingleData.fromJson(jsonData['wlan_ip'] ?? {}),
        time = SmaTime.fromJson(jsonData['time'] ?? {});

  /// Return a JSON representation of the class
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'power': power,
      'energy_today': energyToday,
      'energy_total': energyTotal,
      'L1_power': l1Power,
      'L1_voltage': l1Voltage,
      'L1_current': l1Current,
      'frequency': frequency,
      'dc_power': dcPower,
      'dc_voltage': dcVoltage,
      'dc_current': dcCurrent,
      'operating_time': operatingTime,
      'ethernet_ip': ethernetIp,
      'wlan_ip': wlanIp,
      'time': time
    };
  }
}