import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/screens/common/components/filled_icon_button.dart';
import 'package:safe_streets/screens/map/providers/map_controller.dart';

class MapControlButtons extends ConsumerWidget {
  const MapControlButtons({super.key});

  @override
  Widget build(context, ref) {
    return Column(
      children: <Widget>[
        FilledIconButton(
          onPressed: ref.read(mapControllerProvider.notifier).zoomIn,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: kSpacingSM),
        FilledIconButton(
          onPressed: ref.read(mapControllerProvider.notifier).zoomOut,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(height: kSpacingSM),
        FilledIconButton(
          onPressed: ref.read(mapControllerProvider.notifier).centerOnCurrentPosition,
          icon: const Icon(Icons.my_location),
        ),
      ],
    );
  }
}
