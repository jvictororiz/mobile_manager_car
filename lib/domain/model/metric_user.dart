class MetricUser {
  List<FinancialMovement> debits = [];
  List<FinancialMovement> profit = [];

  MetricUser(this.debits, this.profit);

  factory MetricUser.fromSnapshot(Map<dynamic, dynamic> data) {
    List<Map<dynamic, dynamic>> debits = (data['debits'] ?? []).cast<Map<dynamic, dynamic>>();
    List<Map<dynamic, dynamic>> profit = (data['profit'] ?? []).cast<Map<dynamic, dynamic>>();
    return MetricUser(
      debits.map((item) => FinancialMovement.fromSnapshot(item)).toList(growable: true),
      profit.map((item) => FinancialMovement.fromSnapshot(item)).toList(growable: true),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> debits = this.debits.map((item) => item.toJson()).toList(growable: true);
    List<Map<String, dynamic>> profit = this.profit.map((item) => item.toJson()).toList(growable: true);
    return {
      'debits': debits,
      'profit': profit,
    };
  }
}

class FinancialMovement {
  String description;
  double value;
  DateTime dateTime = DateTime.now();

  FinancialMovement({this.description = "", required this.value, required this.dateTime});

  factory FinancialMovement.fromSnapshot(Map<dynamic, dynamic> data) {
    return FinancialMovement(
      description: data['description'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
      dateTime: data['dateTime'] is int ? DateTime.fromMillisecondsSinceEpoch(data['dateTime']) : data['dateTime'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'value': value,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}
