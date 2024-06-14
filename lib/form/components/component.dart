import 'package:flutter/material.dart';

abstract class Component extends StatelessWidget
{
  late String _name;
  late String _label;
  Component(String name, {Key? key}) : super(key: key)
  {
    _name = name;
    _label = name;
  }


  void setLabel(String label)
  {
    _label = label;
  }

  String getLabel() {
    return _label;
  }
}