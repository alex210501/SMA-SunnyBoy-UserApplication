import 'package:flutter/material.dart';

class EditDeviceTextForm extends StatefulWidget {
  final String? Function(String?) validator;
  final String labelText;
  final String hintText;
  final String initialValue;

  const EditDeviceTextForm(
      {Key? key,
      required this.validator,
      required this.labelText,
      this.hintText = '',
      this.initialValue = ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditDeviceTextFormState();
}

class _EditDeviceTextFormState extends State<EditDeviceTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      validator: widget.validator,
      decoration: InputDecoration(
          labelText: widget.labelText, hintText: widget.hintText),
    );
  }
}

class EditDeviceTextFormPassword extends StatefulWidget {
  final String? Function(String?) validator;
  final String labelText;
  final String hintText;
  final String initialValue;

  const EditDeviceTextFormPassword(
      {Key? key,
      required this.validator,
      required this.labelText,
      this.hintText = '',
      this.initialValue = ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditDeviceTextFormPasswordState();
}

class _EditDeviceTextFormPasswordState
    extends State<EditDeviceTextFormPassword> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      validator: widget.validator,
      obscureText: !_isVisible,
      decoration: InputDecoration(
          suffix: IconButton(
            icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
          ),
          labelText: widget.labelText,
          hintText: widget.hintText),
    );
  }
}
