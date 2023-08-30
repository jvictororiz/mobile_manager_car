import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';

import '../../../../domain/model/historic_type.dart';
import '../../../res/custom_colors.dart';

class TimelineItemWidget extends StatefulWidget {
  final HistoricType item;
  final bool isLastItem;

  const TimelineItemWidget({super.key, required this.item, required this.isLastItem});

  @override
  State<TimelineItemWidget> createState() => _TimelineItemWidgetState();
}

class _TimelineItemWidgetState extends State<TimelineItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.item.getColor(),
                      ),
                      child: Icon(widget.item.getIcon(), color: CustomColors.primaryColor)),
                  if (!widget.isLastItem)
                    Container(
                      height: 70,
                      width: 1,
                      color: Colors.grey,
                    ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 100,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: MarkdownBody(
                      styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(textTheme: TextTheme(bodyText2: TextStyle(fontSize: 12.0, color: Colors.grey)))),
                      data: widget.item.description,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(widget.item.dateTime.dateToString(),textAlign: TextAlign.end, style: const TextStyle(fontSize: 10))),
                    ],
                  ),
                  Divider(color: Colors.grey)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
