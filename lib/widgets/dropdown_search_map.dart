import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

typedef FetchData = Future<List<Map<String, dynamic>>> Function();

class DropdownSearchMap extends StatelessWidget {
  final FetchData fetchData;
  final Map<String, dynamic>? selectedItem;
  final Function(Map<String, dynamic>?) onChanged;

  final String label;
  final String idKey;
  final String textKey;
  final IconData? icon;
  final String? Function(Map<String, dynamic>?)? validator;

  const DropdownSearchMap({
    super.key,
    required this.fetchData,
    required this.onChanged,
    required this.label,
    this.selectedItem,
    this.idKey = 'id',
    this.textKey = 'name',
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Map<String, dynamic>>(
      items: (String filter, LoadProps? props) async {
        return await fetchData();
      },
      selectedItem: selectedItem,
      itemAsString: (item) => item[textKey].toString(),
      compareFn: (a, b) => a[idKey].toString() == b[idKey].toString(),
      onChanged: onChanged,
      validator: validator,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.person, color: Colors.green.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
