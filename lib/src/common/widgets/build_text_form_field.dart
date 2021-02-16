import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {
  final bool isInitialValue;
  final String initialValue;
  final onChanged;
  final String labelText;
  final String hintText;
  final keyboardType;
  final textInputAction;
  final controller;
  final focusNode;
  final requestFocus;
  final Function onSavedCallback;
  final Function saveFormCallback;

  BuildTextFormField({
    this.initialValue,
    this.isInitialValue,
    this.onChanged,
    @required this.labelText,
    this.hintText,
    @required this.keyboardType,
    @required this.textInputAction,
    this.controller,
    @required this.focusNode,
    @required this.requestFocus,
    @required this.onSavedCallback,
    @required this.saveFormCallback,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: isInitialValue ? initialValue : null,
      onChanged: isInitialValue ? onChanged : null,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
      // controller: controller,
      controller: isInitialValue ? null : controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        if (textInputAction == TextInputAction.done) {
          saveFormCallback(context);
        } else {
          FocusScope.of(context).requestFocus(requestFocus);
        }
      },
      validator: (value) {
        if (keyboardType == TextInputType.text) {
          if (value.isEmpty) {
            return 'Please enter a $labelText';
          }
        } else if (keyboardType == TextInputType.multiline) {
          if (value.isEmpty) {
            return 'Please enter a $labelText';
          }

          if (value.length < 10) {
            return 'Should be at least 10 characters long';
          }
        } else if (keyboardType == TextInputType.number) {
          if (value.isEmpty) {
            return 'Please enter a $labelText';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          if (double.parse(value) <= 0) {
            return 'Please enter a number greater than 0';
          }
        } else if (keyboardType == TextInputType.url) {
          if (value.isEmpty) {
            return 'Please enter an image URL';
          }

          if (value.startsWith('http') && !value.startsWith('https')) {
            return 'Please enter a valid image URL';
          }
          if (!value.contains('.png') &&
              !value.contains('.jpg') &&
              !value.contains('.jpeg')) {
            return 'Please enter a valid image URL';
          }
        }

        return null;
      },
      onSaved: onSavedCallback,
    );
  }
}
