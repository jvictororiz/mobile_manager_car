import 'package:mobile_manager_car/core/ext/extension.dart';

import '../model/car.dart';
import '../model/reminder_check.dart';

class ReminderRentValuesUseCase{

  List<String> get(List<Car> carsRunning, List<ReminderCheck?> data, int weekYear) {
    var reminderPaymentCars = carsRunning
        .map((car) {
      var reminderRegistered = data.find((item) => item?.idCar == car.id);
      double remainderValue = 0;
      if (reminderRegistered != null && car.carDriver != null) {
        remainderValue = (car.carDriver?.valueRent ?? car.valueDefaultRent) - reminderRegistered.value;
        if(remainderValue > 0){
          return "O(A) motorista ${car.carDriver?.name} ainda precisa te pagar R\$ ${remainderValue.toString()} ele já pagou R\$ ${reminderRegistered.value}";
        }
      } else {
        remainderValue = car.carDriver?.valueRent ?? car.valueDefaultRent;
      }
      if (remainderValue > 0) {
        return "O(A) motorista ${car.carDriver?.name} ainda precisa te pagar ${remainderValue.toString()} ${car.carDriver?.getDayOfWeekName()} da semana $weekYear";
      }
    })
        .toList(growable: true)
        .filterNotNull();
    return reminderPaymentCars;
  }
}