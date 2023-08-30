import 'package:flutter/material.dart';

class CarDriverEmpty extends StatelessWidget {

  final VoidCallback onTap;
  const CarDriverEmpty({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text("No momento, este carro\n está sem um motorista",style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    onTap.call();
                  },
                  child: const Text("Novo motorista"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
