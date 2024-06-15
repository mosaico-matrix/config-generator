import 'fields/mosaico_field.dart';

class Form {
  String _title = "";
  List<MosaicoField> _fields = [];

  Form();

  void setTitle(String name)
  {
    _title = name;
  }

  String getTitle()
  {
    return _title;
  }


  void addField(MosaicoField field)
  {
    _fields.add(field);
  }

  List<MosaicoField> getFields()
  {
    return _fields;
  }

  void removeField(MosaicoField field)
  {
    _fields.remove(field);
  }

  void clearFields()
  {
    _fields.clear();
  }


}