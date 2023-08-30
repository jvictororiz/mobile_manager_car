class CarDriver {
  String id;
  String name;
  String cpf;
  int dayWeekPayment;
  double valueRent;
  String urlImage;

  CarDriver({
    required this.id,
    required this.name,
    required this.valueRent,
    required this.cpf,
    required this.dayWeekPayment,
    required this.urlImage,
  });

  factory CarDriver.fromMap(Map<dynamic, dynamic> map) {
    return CarDriver(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      valueRent: (map['valueRent'] ?? 0).toDouble(),
      dayWeekPayment: map['dayWeekPayment'] ?? 0,
      cpf: map['cpf'] ?? '',
      urlImage: map['urlImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'valueRent': valueRent,
      'dayWeekPayment': dayWeekPayment,
      'cpf': cpf,
      'urlImage': urlImage,
    };
  }

  String getDayOfWeekName() {
    switch (dayWeekPayment) {
      case 1:
        return "Segunda";
      case 2:
        return "Terça";
      case 3:
        return "Quarta";
      case 4:
        return "Quinta";
      case 5:
        return "Sexta";
      case 6:
        return "Sábado";
      case 7:
        return "Domingo";
      default:
        return "Data inválida";
    }
  }
}
