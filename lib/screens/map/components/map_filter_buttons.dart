import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/screens/map/providers/map_filter.dart';

class MapFilterButtons extends ConsumerWidget {
  MapFilterButtons({super.key});

  final _valuesInOrder = [
    MapFilterValue.dangerPoints,
    MapFilterValue.recommendationPoints,
    MapFilterValue.safePoints,
  ];

  @override
  Widget build(context, ref) {
    final isSelected = _valuesInOrder.map((value) => ref.watch(mapFilterProvider).contains(value)).toList();
    return Material(
      elevation: kElevationS,
      color: Colors.transparent,
      child: ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(kRadiusS)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        constraints: const BoxConstraints(),
        isSelected: isSelected,
        renderBorder: false,
        children: _valuesInOrder.map((value) {
          final index = _valuesInOrder.indexOf(value);
          return MapFilterButton(
            value: value,
            isSelected: isSelected[index],
            isFirst: index == 0,
            isLast: index == _valuesInOrder.length - 1,
            onTap: () => ref.read(mapFilterProvider.notifier).toggleValue(value),
          );
        }).toList(),
      ),
    );
  }
}

class MapFilterButton extends StatelessWidget {
  final void Function()? _onTap;
  final bool _isSelected;
  final bool _isFirst;
  final bool _isLast;
  final IconData _icon;
  final Color _color;

  MapFilterButton({
    required MapFilterValue value,
    void Function()? onTap,
    bool? isSelected,
    bool? isFirst,
    bool? isLast,
    super.key,
  })  : _isSelected = isSelected ?? false,
        _isFirst = isFirst ?? false,
        _isLast = isLast ?? false,
        _onTap = onTap,
        _icon = switch (value) {
          MapFilterValue.safePoints => Icons.health_and_safety,
          MapFilterValue.recommendationPoints => Icons.info,
          MapFilterValue.dangerPoints => Icons.dangerous,
        },
        _color = switch (value) {
          MapFilterValue.safePoints => kColorSafe,
          MapFilterValue.recommendationPoints => kColorRecommendation,
          MapFilterValue.dangerPoints => kColorDanger,
        };

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.only(
          top: kSpacingXS,
          bottom: kSpacingXS,
          left: _isFirst ? kSpacingS : kSpacingXXS,
          right: _isLast ? kSpacingS : kSpacingXXS,
        ),
        color: kWhite,
        child: Icon(
          _icon,
          size: kIcon,
          color: _isSelected ? _color : kGrey,
        ),
      ),
    );
  }
}
