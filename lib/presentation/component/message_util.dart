import 'package:flutter/material.dart';

enum MessageType {
  positive(Colors.green, Colors.white),
  negative(Colors.redAccent, Colors.white),
  alert(Colors.yellow, Colors.black);

  const MessageType(this.backgroundColor, this.textColor);

  final Color backgroundColor;
  final Color textColor;
}

class MessageUtil {
  static showPositiveMessage(String message, BuildContext context) {
    _showMessage(message, context, MessageType.positive);
  }

  static showAlertMessage(String message, BuildContext context) {
    _showMessage(message, context, MessageType.alert);
  }

  static showNegativeMessage(String message, BuildContext context) {
    _showMessage(message, context, MessageType.negative);
  }

  static _showMessage(String message,
      BuildContext context,
      MessageType type,) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        backgroundColor: type.backgroundColor,
        content: Text(
          message,
          style: TextStyle(color: type.textColor),
        ),
      ),
    );
  }

  static showConfirmDialog(BuildContext context, String message, VoidCallback confirmCallback){
    Widget okButton = TextButton(
      child: const Text("Confirmar"),
      onPressed: () {
        confirmCallback.call();
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancelar", style: TextStyle(color: Colors.grey),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Alerta"),
      content: Text(message),
      actions: [
        cancelButton,
        okButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
