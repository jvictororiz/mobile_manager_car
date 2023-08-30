

extension DoubleExtension on double{
  String toPercentageString({int decimalDigits = 2}) {
    final formattedPercentage = toStringAsFixed(decimalDigits);
    return '$formattedPercentage%'.replaceAll(".", ",");
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}