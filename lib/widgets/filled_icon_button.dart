import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class FilledIconButton extends StatelessWidget {
  final Icon _icon;
  final Function() _onPressed;
  final double _size;
  final Color _color;
  final Color _backgroundColor;
  final Color _splashColor;
  final ShapeBorder _border;

  const FilledIconButton({
    Key? key,
    required Icon icon,
    required Function() onPressed,
    double? size,
    Color? color,
    Color? backgroundColor,
    Color? splashColor,
    ShapeBorder? border,
  })  : _icon = icon,
        _onPressed = onPressed,
        _size = size ?? kButton,
        _color = color ?? Colors.white,
        _backgroundColor = backgroundColor ?? Colors.blueAccent,
        _splashColor = splashColor ?? Colors.lightBlue,
        _border = border ?? const CircleBorder(),
        super(key: key);

  @override
  Widget build(context) {
    return Material(
      shape: _border,
      color: _backgroundColor,
      child: InkWell(
        customBorder: _border,
        splashColor: _splashColor,
        onTap: _onPressed,
        child: Container(
          width: _size,
          height: _size,
          alignment: Alignment.center,
          child: Icon(_icon.icon, size: _size / 2, color: _color),
        ),
      ),
    );
  }
}
