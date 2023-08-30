import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../domain/model/car.dart';

extension CarExtension on Car {
  Color getColorTicket() {
    if (inMaintenance) {
      return Colors.redAccent;
    } else if (carDriver == null) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  String getStatus() {
    if (inMaintenance) {
      return "Em manutenção";
    } else if (carDriver == null) {
      return "Disponível";
    } else {
      return "Alugado";
    }
  }
}

extension HistoricTypeExtension on HistoricType {
  IconData getIcon() {
    switch (type) {
      case ChangedOil.id:
        return ChangedOil.getIcon();
      case CarRented.id:
        return CarRented.getIcon();
      case FinishContract.id:
        return FinishContract.getIcon();
      case CarInMaintenance.id:
        return CarInMaintenance.getIcon();
      case PrejudiceCar.id:
        return PrejudiceCar.getIcon();
      case ReturnMaintenance.id:
        return ReturnMaintenance.getIcon();
      case NewCar.id:
        return NewCar.getIcon();
      case PaymentCar.id:
        return PaymentCar.getIcon();
      case RegisterKM.id:
        return RegisterKM.getIcon();
      default:
        return Icons.notification_add;
    }
  }

  Color getColor() {
    switch (type) {
      case ChangedOil.id:
        return ChangedOil.getColor();
      case CarRented.id:
        return CarRented.getColor();
      case FinishContract.id:
        return FinishContract.getColor();
      case CarInMaintenance.id:
        return CarInMaintenance.getColor();
      case PrejudiceCar.id:
        return PrejudiceCar.getColor();
      case ReturnMaintenance.id:
        return ReturnMaintenance.getColor();
      case NewCar.id:
        return NewCar.getColor();
      case PaymentCar.id:
        return PaymentCar.getColor();
      case RegisterKM.id:
        return RegisterKM.getColor();
      default:
        return Colors.blue;
    }
  }
}

extension ListFlatten<T> on List<List<T>> {
  List<T> flatten() {
    return expand((list) => list).toList();
  }

// T? find(bool Function(T element) onCall) {
//   for (var element in this) {
//     if (onCall.call(element)) {
//       return element;
//     }
//   }
//   return null;
// }
}

extension ListExtension<T> on List<T> {
  T? find(bool Function(T element) onCall) {
    for (var element in this) {
      if (onCall(element)) {
        return element;
      }
    }
    return null;
  }

  bool all(bool Function(T) test) {
    for (final element in this) {
      if (!test(element)) {
        return false;
      }
    }
    return true;
  }

  double sum(num Function(T) getValue) {
    return isEmpty ? 0 : map(getValue).reduce((value, element) => value + element).toDouble();
  }
}

extension ListExtensionNotNull<T> on List<T?> {
  List<T> filterNotNull() {
    return [
      for (var element in this)
        if (element != null) element
    ];
  }
}

extension XFileToFile on XFile {
  File toFile() {
    return File(path);
  }
}

extension ListXFileToListFile on List<XFile> {
  List<File> toFiles() {
    return map((item) => item.toFile()).toList(growable: true);
  }
}

extension XFileToImage on XFile {
  Image toImageWidget() {
    return Image.file(File(path));
  }
}

extension ImageUrlListToWidgetList on List<String> {
  List<Widget> toImageWidgetList(Function(String)? onLongPress, VoidCallback onTap) {
    return List<Widget>.generate(length, (index) {
      return this[index].toImageWidget(onLongPress, onTap);
    });
  }
}

extension FileExtension on File {
  Widget toImageWidget(Function(File) onTap) {
    return InkWell(
        onLongPress: () {
          onTap.call(this);
        },
        child: Image.file(
          this,
          fit: BoxFit.fitWidth,
        ));
  }
}

extension StringExtension on String {
  String getIdImage() {
    int startIndex = indexOf('%2F');
    int endIndex = indexOf('?alt', startIndex);
    var newText = substring(startIndex, endIndex);
    newText = newText.replaceFirst("%2F", "");
    newText = newText.replaceFirst("%2F", "");
    return newText.substring(newText.indexOf("%2F")).replaceFirst("%2F", "");
  }

  Widget toImageWidget(Function(String)? onLongPress, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      onLongPress: () {
        onLongPress?.call(this);
      },
      child: Image.network(
        this,
        fit: BoxFit.fitWidth,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  toDate(String pattern) {
    return DateFormat(pattern).parse(this);
  }

  DateTime? toDateDefaultPattern() {
    try {
      return DateFormat("dd/MM/yyyy").parse(this);
    } catch (exception) {
      return null;
    }
  }

  double toWeight() {
    try {
      return double.parse(replaceAll(",", "."));
    } catch (ex) {
      return 0;
    }
  }

  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }

  String removingCharacters() {
    return replaceAll(".", "").replaceAll("-", "");
  }

  String ifEmpty(String Function() action) {
    if (isEmpty) {
      return action();
    } else {
      return this;
    }
  }
}

extension DateTimeExtension on DateTime {
  String dateToString() {
    return DateFormat("dd/MM/yyyy").format(this);
  }

  String dateToStringWithPattern(String pattern) {
    return DateFormat(pattern, 'pt_Br').format(DateTime.now());
  }

  String getDateDurationString(DateTime finish) {
    Duration differenceDuration = difference(finish);

    if (differenceDuration.inDays < 7) {
      return "${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'Dia' : 'dias'}";
    } else if (differenceDuration.inDays < 30) {
      int weeks = differenceDuration.inDays ~/ 7;
      return "$weeks ${weeks == 1 ? 'Semana' : 'Semanas'}";
    } else if (differenceDuration.inDays < 365) {
      int months = differenceDuration.inDays ~/ 30;
      return "$months ${months == 1 ? 'Mês' : 'Meses'}";
    } else {
      int years = differenceDuration.inDays ~/ 365;
      return "$years ${years == 1 ? 'Ano' : 'Anos'}";
    }
  }
}

extension ColorExtension on Color {
  toHex() {
    return '#${value.toRadixString(16).substring(2, 8)}';
  }
}

extension IntExtension on int {
  bool isValidDate() {
    try {
      var date = DateTime.fromMillisecondsSinceEpoch(this);
      var stringDate = date.dateToString();
      stringDate.toDateDefaultPattern();
      return true;
    } catch (ex) {
      return false;
    }
  }
}

extension CustomList<T> on List<T> {
  List<T> filterItems(bool Function(T) filter) {
    List<T> filterList = List.empty();
    for (var element in this) {
      if (filter(element)) {
        filterList = List.from(filterList)..add(element);
      }
    }
    return filterList;
  }
}
