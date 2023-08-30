class ReminderCheck {
  String idCar;
  double value;

  ReminderCheck(this.idCar, this.value);

 static ReminderCheck? fromSnapshot(Map<dynamic, dynamic> data) {
    try{
      return ReminderCheck(
        data['idCar'] ?? '',
        (data['value'] ?? 0).toDouble(),
      );
    }catch(ex){
      return null;
    }

  }

  Map<String, dynamic> toJson() {
    return {
      'idCar': idCar,
      'value': value,
    };
  }
}
