import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class OutlinedIconTextButton extends StatelessWidget {
  final Icon _icon;
  final String _label;
  final Function() _onPressed;
  final double _size;
  final Color _color;
  final Color _borderColor;
  final Color _splashColor;

  const OutlinedIconTextButton({
    Key? key,
    required Icon icon,
    required String label,
    required Function() onPressed,
    double? size,
    Color? color,
    Color? borderColor,
    Color? splashColor,
    ShapeBorder? border,
  })  : _icon = icon,
        _label = label,
        _onPressed = onPressed,
        _size = size ?? kButton,
        _color = color ?? kBlack,
        _borderColor = borderColor ?? kBlack,
        _splashColor = splashColor ?? kLightGrey,
        super(key: key);

  @override
  Widget build(context) {
    return OutlinedButton(
      // shape: _border,
      // color: _backgroundColor,
      onPressed: _onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButton),
        ),
        side: BorderSide(width: kBorder, color: _color),
      ),
      child: Row(
        children: [
          Icon(_icon.icon, color: _color),
          const SizedBox(width: kSpacingS),
          Text(
            _label,
            style: TextStyle(
              fontSize: kTextXS,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}
