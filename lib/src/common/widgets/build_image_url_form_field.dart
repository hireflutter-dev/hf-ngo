import 'package:flutter/material.dart';

import 'build_text_form_field.dart';

class BuildImageUrlFormField extends StatelessWidget {
  final String labelText;
  final String multiLines;
  final keyboardType;
  final textInputAction;
  final urlController;
  final focusNode;
  final requestFocus;
  final String done;
  final Function onSavedCallback;
  final Function saveFormCallback;

  const BuildImageUrlFormField({
    @required this.labelText,
    this.multiLines,
    @required this.keyboardType,
    @required this.textInputAction,
    @required this.urlController,
    @required this.focusNode,
    this.done,
    @required this.requestFocus,
    @required this.onSavedCallback,
    @required this.saveFormCallback,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: urlController.text.isEmpty
              ? Center(child: Text('Enter a URL'))
              : FittedBox(
                  child: Image.network(urlController.text),
                  fit: BoxFit.cover,
                ),
        ),
        Expanded(
          child: BuildTextFormField(
            labelText: labelText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            controller: urlController,
            focusNode: focusNode,
            requestFocus: requestFocus,
            onSavedCallback: onSavedCallback,
            saveFormCallback: saveFormCallback,
            isInitialValue: false,
          ),
        ),
      ],
    );
  }
}
