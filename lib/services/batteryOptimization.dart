import 'package:disable_battery_optimization/disable_battery_optimization.dart';

class BatteryOptimization {
  isBatteryOptimizationDisabled() async
  //eğer pil optimizasyonu yoksa false döner varsa true döner
  {
    bool? isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    print('isBatteryOptimizationDisabled');
    print(isBatteryOptimizationDisabled);
    return isBatteryOptimizationDisabled;
  }

  showDisableBatteryOptimizationSettings()
  //pil optimizasyon ekranını açar.
  {
    DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
  }
}
