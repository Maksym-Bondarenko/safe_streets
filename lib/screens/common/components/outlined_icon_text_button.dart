import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class OutlinedIconTextButton extends StatelessWidget {
  final Icon _icon;
  final String _label;
  final void Function() _onPressed;
  final double _size;
  final Color _color;
  final Color _borderColor;
  final Color _splashColor;

  const OutlinedIconTextButton({
    super.key,
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
        _size = size ?? kSizeButton,
        _color = color ?? kBlack,
        _borderColor = borderColor ?? color ?? kBlack,
        _splashColor = splashColor ?? kLightGrey;

  @override
  Widget build(context) {
    return OutlinedButton(
      onPressed: _onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        shape: const StadiumBorder(),
        side: BorderSide(width: kSizeBorder, color: _borderColor),
        padding: const EdgeInsets.symmetric(
          horizontal: kSpacingSM,
          vertical: kSpacingXS,
        ),
      ),
      child: Row(
        children: [
          Icon(_icon.icon, color: _color),
          const SizedBox(width: kSpacingXS),
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
