import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/modules/config_form/fields/mosaico_field.dart';
import 'package:provider/provider.dart';

import '../models/dynamic_form_model.dart';

/**
 * This widget is used to display a dynamic form based on the user's configuration
 * It will display the list of fields provided by the dynamic_form_state
 */
class DynamicForm extends StatelessWidget {
  const DynamicForm({super.key});

  @override
  Widget build(BuildContext context) {

    // Get generated form model
    var formModel = Provider.of<DynamicFormModel>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ListView(
            children: [
              _buildHeader(formModel.getTitle(), formModel.getDescription()),
              SizedBox(height: 20),
              _buildForm(formModel.getFields(), formModel.getFormKey()),
            ],
          ),
      ),
    );
  }

  Widget _buildForm(List<MosaicoField> fields, GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          for (var field in fields)
            field
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Form header
          Column(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              // Render form description
              Text(description,
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}