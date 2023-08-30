class HistoricOil {
  double currentKm;
  double value;
  DateTime currentDate;

  HistoricOil(this.currentKm, this.value, this.currentDate);

  factory HistoricOil.fromSnapshot(Map<dynamic, dynamic> data) {
    double currentKm =(data['currentKm'] ?? 0).toDouble();
    double value =(data['value'] ?? 0).toDouble();
    int currentDate = (data['currentDate'] ?? 0).toInt();
    return HistoricOil(currentKm,value, DateTime.fromMillisecondsSinceEpoch(currentDate));
  }

  Map<String, dynamic> toJson() {
    return {
      'currentKm': currentKm,
      'currentDate': currentDate.millisecondsSinceEpoch,
    };
  }
}
