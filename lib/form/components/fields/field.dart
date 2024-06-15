import 'package:flutter/material.dart';

abstract class Field extends StatelessWidget
{
  final String _name;
  late String _label;
  Field(this._name, {Key? key}) : super(key: key)
  {
    _label = _name;
  }


  void setLabel(String label)
  {
    _label = label;
  }

  String getLabel() {
    return _label;
  }
}