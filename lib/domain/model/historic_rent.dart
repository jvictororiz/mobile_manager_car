class HistoricRent {
  String driverName;
  String carName;
  double valueRent;
  DateTime dateInit;
  DateTime? dateFinish;

  HistoricRent({required this.driverName, required this.carName, required this.dateInit, this.dateFinish, required this.valueRent});

  factory HistoricRent.fromSnapshot(Map<dynamic, dynamic> data) {
    return HistoricRent(
      driverName: data['driverName'] ?? '',
      valueRent: data['valueDefaultRent'] ?? 0,
      carName: data['carName'] ?? '',
      dateInit: data['dateInit'] is int
          ? DateTime.fromMillisecondsSinceEpoch(data['dateInit'])
          : data['dateInit'] ?? DateTime.now(),

      dateFinish: data['dateFinish'] is int
          ? DateTime.fromMillisecondsSinceEpoch(data['dateFinish'])
          : data['dateFinish'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'carName': carName,
      'valueRent': valueRent,
      'dateInit': dateInit.millisecondsSinceEpoch,
      'dateFinish': dateFinish?.millisecondsSinceEpoch,
    };
  }
}
