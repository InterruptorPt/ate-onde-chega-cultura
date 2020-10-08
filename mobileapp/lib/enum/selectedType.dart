import 'package:flutter/material.dart';
import 'package:mobileapp/domain/managers/binding_manager.dart';
import 'package:mobileapp/domain/model/Binding.dart';

enum SelectedType {
  CINEMA,
  MUSEUM,
}

extension SelectedTypeExtension on SelectedType {
  String get typeId {
    switch (this) {
      case SelectedType.CINEMA:
        return 'Q41253';
      case SelectedType.MUSEUM:
        return 'Q33506';
    }
  }

  IconData get iconData {
    switch (this) {
      case SelectedType.CINEMA:
        return Icons.movie;
      case SelectedType.MUSEUM:
        return Icons.museum;
    }
  }

  Future<List<Binding>> get getBindings async {
    BindingManager bindingManager = BindingManager();
    return bindingManager.getBindings(this);
  }
}
