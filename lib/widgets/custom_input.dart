import 'package:e_commerce/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final isPasswordField;

  CustomInput({this.hintText, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.isPasswordField});

  @override
  Widget build(BuildContext context) {

    bool _isPasswordField = isPasswordField ?? false;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 14.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadiusDirectional.circular(12.0),
      ),
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,

      decoration: InputDecoration(
        border: InputBorder.none,
        hintText:hintText ?? "Hint Text..",
          contentPadding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 20.0,
      )
      ),
        style: Constants.regularDarkText,
      ),
    );
  }
}
