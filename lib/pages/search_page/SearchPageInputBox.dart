// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPageInputBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode listTileFocusNode;
  final FocusNode backButtonFocusNode;
  final Function(String) onChanged;

  final FocusNode textFieldNode = FocusNode();

  SearchPageInputBox({
    @required this.controller,
    @required this.listTileFocusNode,
    @required this.onChanged,
    @required this.backButtonFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: textFieldNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          backButtonFocusNode.requestFocus();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          listTileFocusNode.requestFocus();
        }
      },
      child: TextField(
        controller: controller,
        autofocus: true,
        cursorColor: Theme.of(context).accentColor,
        onSubmitted: (value) => listTileFocusNode.requestFocus(),
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
        ),
        onChanged: (text) {
          onChanged(text);
        },
      ),
    );
  }
}
