import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../res/strings.dart';

class SelectImageBottomSheet extends StatelessWidget {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;

  const SelectImageBottomSheet({super.key, required this.onTapCamera, required this.onTapGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 16),
          Center(
            child: Container(width: 64, height: 1, color: Colors.black38,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right:32, bottom: 16, top: 16),
            child: Text(Strings.selectTypeImage, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Divider(color: Colors.black54,),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(Strings.camera),
            onTap: () {
              onTapCamera.call();
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.black54,),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text(Strings.gallery),
            onTap: () {
              onTapGallery.call();
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.black54,),
        ],
      ),
    );
  }
}
