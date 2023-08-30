import 'package:flutter/material.dart';

class ScreenBuilderComponent extends StatelessWidget {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final bool isEmpty;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? successWidget;
  final Widget? emptyWidget;

  const ScreenBuilderComponent(
      {Key? key, this.loadingWidget, this.errorWidget, this.successWidget, this.emptyWidget, required this.isLoading, required this.isError, required this.isSuccess, required this.isEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const SizedBox();
    }
    if (isError) {
      return errorWidget ?? const SizedBox();
    }
    if (isEmpty) {
      return emptyWidget ?? const SizedBox();
    }
    if (isSuccess) {
      return successWidget ?? const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}
