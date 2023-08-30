import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';
import 'package:mobile_manager_car/presentation/component/message_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/text_icon.dart';
import '../../../res/images.dart';
import '../../../res/strings.dart';

class ItemDriverComponent extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;

  const ItemDriverComponent({super.key, required this.driver, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var firstImage = driver.images.isEmpty ? "" : driver.images.first;
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Wrap(
        children: [
          Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  firstImage.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            firstImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            Images.icDriverDefault,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    driver.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  IconText(
                    textAlign: TextAlign.center,
                    text: driver.cpf,
                    icon: Icons.key,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  IconText(
                    text: driver.phoneNumber,
                    icon: Icons.phone_android,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child: IconButton(
                            color: Colors.blue,
                              onPressed: () async {
                                Uri url = Uri(scheme: "tel", path: driver.phoneNumber.replaceAll("-", ""));
                                await launchUrl(url);
                              },
                              icon: const Icon(Icons.call))),
                      Expanded(
                          child: IconButton(
                            color: Colors.green,
                              onPressed: () async {
                                var contact = driver.phoneNumber;
                                var androidUrl = "whatsapp://send?phone=$contact";
                                var iosUrl = "https://wa.me/$contact?}";

                                try {
                                  if (Platform.isIOS) {
                                    await launchUrl(Uri.parse(iosUrl));
                                  } else {
                                    await launchUrl(Uri.parse(androidUrl));
                                  }
                                } on Exception {
                                  MessageUtil.showNegativeMessage("Whatsapp não está instalado", context);
                                }
                              },
                              icon: Icon(Icons.whatsapp))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
