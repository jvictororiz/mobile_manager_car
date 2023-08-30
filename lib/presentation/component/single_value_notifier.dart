import 'package:flutter/material.dart';

class SingleValueNotifier<T> extends ValueNotifier<T?> {
  SingleValueNotifier(super.value);

  @override
  set value(T? newValue) {
    super.value = newValue;
  }
}
