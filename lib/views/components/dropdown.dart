import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<dynamic> items;
  final dynamic selectedItem;
  final ValueChanged<dynamic> onChanged;
  final String? valueFieldName;
  final String? labelFieldName;
  final double? height;
  final double? width;
  final double? borderRadius;

  const CustomDropdownMenu({
    super.key,
    required this.items,
    this.selectedItem,
    this.height,
    this.width,
    this.borderRadius,
    this.labelFieldName,
    this.valueFieldName,
    required this.onChanged,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  final TextEditingController dropdownController = TextEditingController();
  dynamic _selectedItem;
  String? valueFieldName;
  String? labelFieldName;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    valueFieldName = widget.valueFieldName;
    labelFieldName = widget.labelFieldName;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {
        _selectedItem = widget.selectedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.width ?? MediaQuery.of(context).size.width / 2,
      height: widget.height ?? 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 9.0),
        color: const Color(0xFF686E76),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: DropdownButton<dynamic>(
        value: _selectedItem,
        iconEnabledColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, size: 28.0),
        dropdownColor: const Color(0xFF15182C),
        items: widget.items.map((dynamic item) {
          item.toJson();
          var value = item is String
              ? item
              : valueFieldName != null
                  ? item.toJson()[valueFieldName!]
                  : item;
          var label = item is String ? item : item.toJson()[labelFieldName!];
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              child: Text(label,
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ),
          );
        }).toList(),
        onChanged: (dynamic newValue) {
          setState(() {
            _selectedItem = newValue;
            widget.onChanged(newValue);
          });
        },
        isExpanded:
            true, // Make the dropdown take the full width of the container
        underline: Container(), // Remove the underline
      ),
    );
  }
}
