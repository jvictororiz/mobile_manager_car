import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import 'model/historic_header_model.dart';

class TimelineHeaderItems extends StatefulWidget {
  final List<HistoricHeaderModel> tabs;
  final Function(HistoricType) onChange;

  const TimelineHeaderItems({Key? key, required this.tabs, required this.onChange}) : super(key: key);

  @override
  State<TimelineHeaderItems> createState() => _TimelineHeaderItemsState();
}

class _TimelineHeaderItemsState extends State<TimelineHeaderItems> {
  var itemSelected = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = 150.0;
    return Container(
        height: 120,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.tabs.length,
          itemBuilder: (context, index) {
            var item = widget.tabs[index];
            final itemKey = GlobalKey();
            return Padding(
              key: itemKey,
              padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: index == widget.tabs.length - 1 ? 16 : 0),
              child: Container(
                width: width,
                height: 10,
                child: InkWell(
                  onTap: () {
                    var renderObject = itemKey.currentContext?.findRenderObject();
                    _scrollController.position.ensureVisible(
                      renderObject!,
                      alignment: 0.5, // How far into view the item should be scrolled (between 0 and 1).
                      duration: const Duration(milliseconds: 300),
                    );
                    setState(() {
                      itemSelected = index;
                    });
                    widget.onChange.call(item.historicType);
                  },
                  child: Card(
                    elevation: 5,
                    color: index == itemSelected ? Colors.blue : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.historicType.getIcon(), color: index == itemSelected ? Colors.white : Colors.black),
                        SizedBox(height: 12),
                        Center(
                          child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: index == itemSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
