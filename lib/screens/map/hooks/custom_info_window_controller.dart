import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

CustomInfoWindowController useCustomInfoWindowController() {
  return use(const _CustomInfoWindowControllerHook());
}

class _CustomInfoWindowControllerHook extends Hook<CustomInfoWindowController> {
  const _CustomInfoWindowControllerHook();

  @override
  _CustomInfoWindowControllerHookState createState() => _CustomInfoWindowControllerHookState();
}

class _CustomInfoWindowControllerHookState
    extends HookState<CustomInfoWindowController, _CustomInfoWindowControllerHook> {
  late final CustomInfoWindowController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = CustomInfoWindowController();
  }

  @override
  CustomInfoWindowController build(BuildContext context) {
    return _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
