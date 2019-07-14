import 'package:flutter/material.dart';

class MyEditableText extends StatefulWidget {
  MyEditableText(
      {@required this.defaultData,
      @required this.onSubmitted,
      this.autofocus = false,
      this.softWrap = false,
      this.style,
      this.maxLines = 1})
      : assert(defaultData != null, "defaultData == null"),
        assert(onSubmitted != null, "onSubmitted == null");

  final String defaultData;
  final bool softWrap;
  final bool autofocus;
  final TextStyle style;
  final int maxLines;
  final ValueChanged<String> onSubmitted;

  @override
  _MyEditableTextState createState() => _MyEditableTextState();
}

class _MyEditableTextState extends State<MyEditableText> {
  String data;
  bool editEnabled = false;

  @override
  void initState() {
    data = widget.defaultData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (editEnabled) {
      return TextField(
        controller: TextEditingController(text: data),
        style: widget.style,
        maxLines: widget.maxLines,
        autofocus: widget.autofocus,
        onSubmitted: (String newValue) {
          setState(() {
            data = newValue;
            editEnabled = false;
          });
          widget.onSubmitted(newValue);
        },
      );
    } else {
      return GestureDetector(
        child: Text(
          data,
          softWrap: widget.softWrap,
          style: widget.style,
        ),
        onTap: () {
          setState(() {
            editEnabled = true;
          });
        },
      );
    }
  }
}
