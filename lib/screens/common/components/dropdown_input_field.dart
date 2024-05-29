import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class DropdownInputField<T> extends DropdownButtonFormField<T> {
  DropdownInputField({
    super.key,
    super.onChanged,
    super.value,
    super.hint,
    super.items,
  }) : super(
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          elevation: 15,
          decoration: const InputDecoration(
            hintText: 'Title',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kGreen, width: kSizeBorder),
            ),
          ),
        );
}
