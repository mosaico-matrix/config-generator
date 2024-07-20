import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../states/dynamic_form_state.dart';
import 'fields/mosaico_field.dart';

/**
 * This widget is used to display a dynamic form based on the user's configuration
 * It will display the list of fields provided by the [DynamicFormState]
 */
class DynamicForm extends StatelessWidget {
  const DynamicForm({super.key});

  @override
  Widget build(BuildContext context) {

    // Get generated form model
    var formModel = Provider.of<DynamicFormState>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ListView(
            children: [

              // Header
              _buildHeader(formModel.getTitle(), formModel.getDescription()),
              SizedBox(height: 20),

              // Form
              _buildForm(formModel.getFields(), formModel.getFormKey()),
            ],
          ),
      ),
    );
  }

  /// Builds the form based on the fields provided
  /// Shares the key with the form state in order to validate the form the main widget
  Widget _buildForm(List<MosaicoField> fields, GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Actual form fields
          for (var field in fields)
            field
        ],
      ),
    );
  }

  /// Builds the header of the form
  /// It will display the title and description of the form
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
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}