import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../res/strings.dart';

class OptionsImageBottomSheet extends StatelessWidget {
  final VoidCallback onTapDownload;
  final VoidCallback onTapDelete;

  const OptionsImageBottomSheet({super.key, required this.onTapDownload, required this.onTapDelete});

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
            child: Text(Strings.selectOptionsTypeImage, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Divider(color: Colors.black54,),
          ListTile(
            leading: Icon(Icons.download),
            title: Text(Strings.download),
            onTap: () {
              onTapDownload.call();
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.black54,),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text(Strings.deleteImage, style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              onTapDelete.call();
              Navigator.pop(context);
            },
          ),
          Divider(color: Colors.black54,),
        ],
      ),
    );
  }
}
