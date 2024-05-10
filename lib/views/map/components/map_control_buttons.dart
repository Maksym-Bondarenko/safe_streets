import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/views/map/providers/map_controller.dart';
import 'package:safe_streets/widgets/filled_icon_button.dart';

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
