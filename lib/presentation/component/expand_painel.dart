import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

class ExpandablePanel extends StatefulWidget {
  final Widget? header;
  final Widget child;
  final VoidCallback? onTapUser;
  final Color colorHeader;
  final IconData iconHide;
  final double heightHeader;
  final double round;

  const ExpandablePanel({
    super.key,
    this.header,
    required this.child,
    this.onTapUser,
    this.iconHide = Icons.keyboard_arrow_down,
    this.colorHeader = CustomColors.primaryColor,
    this.heightHeader = 25,
    this.round = 0.0,
  });

  @override
  _ExpandablePanelState createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(widget.round),
        color: widget.colorHeader,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: widget.heightHeader,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _isExpanded ? Icons.remove : widget.iconHide,
                      color: Colors.white,
                    ),
                    SizedBox(width: widget.header != null ? 12 : 0),
                    Container(child: widget.header != null ? widget.header! : const SizedBox())
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.onTapUser?.call();
              },
              child: AnimatedCrossFade(
                firstChild: Container(),
                secondChild: widget.child,
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
                firstCurve: Curves.bounceInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
