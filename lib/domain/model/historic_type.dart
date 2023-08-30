import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';

import 'car.dart';
import 'historic_oil.dart';
import 'historic_rent.dart';

class HistoricType {
  int type;
  DateTime dateTime;
  String title = "";
  String description = "";

  HistoricType(this.type, this.dateTime);

  String getTitle() {
    return "";
  }

  String getDescription() {
    return "";
  }

  factory HistoricType.fromSnapshot(Map<dynamic, dynamic> data) {
    var historicType = HistoricType(
      data['type'] ?? 0,
      data['dateTime'] is int ? DateTime.fromMillisecondsSinceEpoch(data['dateTime']) : data['dateTime'] ?? DateTime.now(),
    );
    historicType.title = data['title'] ?? '';
    historicType.description = data['description'] ?? '';
    return historicType;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': getTitle(),
      'description': getDescription(),
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}

// User historic

class ChangedOil extends HistoricType {
  static const id = 1;
  Car car;
  HistoricOil historicOil;

  ChangedOil(this.historicOil, this.car) : super(id, historicOil.currentDate);

  @override
  String getTitle() {
    return "Troca de óleo";
  }

  @override
  String getDescription() {
    return "Troca de óleo do **${car.getNameAndPlate()}** aos **${historicOil.currentKm}KM**, custou **${historicOil.value}KM**";
  }

  static IconData getIcon() {
    return FontAwesomeIcons.oilCan;
  }

  static Color getColor() {
    return Colors.blue;
  }
}

class CarInMaintenance extends HistoricType {
  static const id = 4;
  Car car;
  String motive;
  DateTime date;

  CarInMaintenance(this.motive, this.car, this.date) : super(id, date);

  @override
  String getTitle() {
    return "Carro em manutenção";
  }

  @override
  String getDescription() {
    return "O **${car.getNameAndPlate()}** entrou em manutenção pelo motivo:\n**$motive** ";
  }

  static IconData getIcon() {
    return FontAwesomeIcons.screwdriverWrench;
  }

  static Color getColor() {
    return Colors.redAccent;
  }
}

class PrejudiceCar extends HistoricType {
  static const id = 5;
  Car car;
  double prejudice;
  String observation;
  DateTime date;

  PrejudiceCar(this.prejudice, this.car, this.date, this.observation) : super(id, date);

  @override
  String getTitle() {
    return "Débito registrado";
  }

  @override
  String getDescription() {
    return "O **${car.getNameAndPlate()}**  teve um gasto de **$prejudice**, motivo:\n$observation";
  }

  static IconData getIcon() {
    return FontAwesomeIcons.carBurst;
  }

  static Color getColor() {
    return Colors.red;
  }
}

class ReturnMaintenance extends HistoricType {
  static const id = 6;
  Car car;
  String motive;
  DateTime date;
  double value;

  ReturnMaintenance(this.motive, this.car, this.date, this.value) : super(id, date);

  @override
  String getTitle() {
    return "Retorno da manutenção";
  }

  @override
  String getDescription() {
    return "O **${car.getNameAndPlate()}**  retornou da manutenção,custou **$value** e o motivo foi **$motive** ";
  }

  static IconData getIcon() {
    return FontAwesomeIcons.car;
  }

  static Color getColor() {
    return Colors.blueAccent;
  }
}

class PaymentCar extends HistoricType {
  static const id = 8;
  HistoricRent historicRent;
  DateTime date;

  PaymentCar(this.historicRent, this.date) : super(id, date);

  @override
  String getTitle() {
    return "Pagamento realizado";
  }

  @override
  String getDescription() {
    return "Pagamento registrado, **${historicRent.driverName}** pagou **${historicRent.valueRent}** do **${historicRent.carName}**";
  }

  static IconData getIcon() {
    return Icons.attach_money_outlined;
  }

  static Color getColor() {
    return Colors.lightGreen;
  }
}

class RegisterKM extends HistoricType {
  static const id = 9;
  double newKm = 0;
  DateTime date;
  Car car;

  RegisterKM(this.newKm, this.date, this.car) : super(id, date);

  @override
  String getTitle() {
    return "Atualização de kilometragem";
  }

  @override
  String getDescription() {
    return "O veículo **${car.getNameAndPlate()}** está com **$newKm** KM";
  }

  static IconData getIcon() {
    return Icons.car_repair;
  }

  static Color getColor() {
    return Colors.blue;
  }
}

// Application Historic
class FinishContract extends HistoricType {
  static const id = 3;
  final HistoricRent historicRent;

  FinishContract(this.historicRent) : super(id, DateTime.now());

  @override
  String getTitle() {
    return "Contrato encerrado";
  }

  @override
  String getDescription() {
    return "O contrado do(a) **${historicRent.driverName}** com o **${historicRent.carName}** se encerrou, durou **${historicRent.dateInit.getDateDurationString(historicRent.dateFinish!)}**";
  }

  static IconData getIcon() {
    return FontAwesomeIcons.fileContract;
  }

  static Color getColor() {
    return Colors.yellow;
  }
}

class CarRented extends HistoricType {
  static const id = 2;
  final Car car;
  final double valueRent;

  CarRented(this.car, this.valueRent) : super(id, DateTime.now());

  @override
  String getTitle() {
    return "Carro alugado";
  }

  @override
  String getDescription() {
    return "**${car.carDriver?.name ?? "vazio"}** alugou o **${car.getNameAndPlate()}** por **R\$ $valueRent** semanal para pagar todas as **${car.carDriver?.getDayOfWeekName()}(s)**";
  }

  static IconData getIcon() {
    return Icons.attach_money;
  }

  static Color getColor() {
    return Colors.lightGreen;
  }
}

class NewCar extends HistoricType {
  static const id = 7;
  final Car car;

  NewCar(this.car) : super(id, DateTime.now());

  @override
  String getTitle() {
    return "Novo carro";
  }

  @override
  String getDescription() {
    return "Parabéns, você adquiriu um **${car.getNameAndPlate()}**";
  }

  static IconData getIcon() {
    return Icons.local_car_wash_outlined;
  }

  static Color getColor() {
    return Colors.blue;
  }
}
