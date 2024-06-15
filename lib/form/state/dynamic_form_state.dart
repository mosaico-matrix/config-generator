import 'dart:convert';

import 'package:flutter/material.dart' show ChangeNotifier;
import '../form.dart';

/// This class represents the state of the dynamic form.
class DynamicFormState extends ChangeNotifier {

  late Form _form;

  DynamicFormState(this._form);

  Form getForm() {
    return _form;
  }
}
