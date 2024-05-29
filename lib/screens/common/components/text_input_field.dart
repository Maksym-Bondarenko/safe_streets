import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class TextInputField extends TextFormField {
  TextInputField({
    super.key,
    super.controller,
    super.validator,
    super.maxLines,
    super.minLines,
    super.keyboardType,
    String? hintText,
  }) : super(
          cursorColor: kGreen,
          decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kGreen, width: kSizeBorder),
            ),
          ),
        );
}
