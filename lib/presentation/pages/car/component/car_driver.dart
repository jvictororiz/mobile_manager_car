import 'package:flutter/material.dart';

import '../../../res/images.dart';

class CarDriverComponent extends StatelessWidget {
  final String urlDriver;
  final String driverName;
  final String driverDocument;
  final VoidCallback onTapDriver;
  final VoidCallback onTap;
  final VoidCallback onRemoverDriver;

  const CarDriverComponent({Key? key, required this.urlDriver, required this.driverDocument, required this.driverName, required this.onTap, required this.onRemoverDriver, required this.onTapDriver})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapDriver.call();
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey,
                  child: urlDriver.isEmpty
                      ? Image.asset(Images.defaultCar, fit: BoxFit.fitWidth)
                      : Image.network(
                          urlDriver,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(driverName, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(driverDocument),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        child: Text("Desvincular", style: TextStyle(fontSize: 12, color: Colors.redAccent)),
                        onPressed: () {
                          _showAlertDialogConfirm(context);
                        },
                      ),
                      OutlinedButton(
                        onPressed: () {
                          onTap.call();
                        },
                        child: const Text("Alterar", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialogConfirm(BuildContext context) {
      Widget cancelButton = TextButton(
        child: Text("Cancelar"),
        onPressed:  () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("Sim"),
        onPressed:  () {
          Navigator.pop(context);
          onRemoverDriver.call();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alerta"),
        content: Text("Tem certeza que deseja desvincular esse motorista?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }
}
