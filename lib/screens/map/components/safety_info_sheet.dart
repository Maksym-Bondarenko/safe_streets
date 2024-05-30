import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/router.dart';
import 'package:safe_streets/screens/common/components/outlined_icon_text_button.dart';
import 'package:safe_streets/screens/map/providers/safety_info.dart';
import 'package:safe_streets/screens/map/providers/selected_place.dart';

import 'safety_scale.dart';

const _fallbackLocationName = '----';

class SafetyInfoSheet extends ConsumerWidget {
  const SafetyInfoSheet({super.key});

  @override
  Widget build(context, ref) {
    final locationName = ref.watch(selectedPlaceNameProvider).valueOrNull ?? _fallbackLocationName;
    final info = ref.watch(safetyInfoProvider).valueOrNull;
    final rating = info?.rating ?? 0;
    final label = info?.label ?? '--';
    final description = info?.description ?? '';
    final color = info?.color ?? kGrey;
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        child: DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.5,
          snap: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kRadiusL),
                  topRight: Radius.circular(kRadiusL),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: kSpacingSM),
                          child: _BottomSheetHandle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kSpacingXXXS),
                        child: Text(
                          locationName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: kTextML),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(color: color, fontSize: kTextM),
                          ),
                          const Text(
                            '/5',
                            style: TextStyle(fontSize: kTextM, color: kGrey),
                          ),
                          const SizedBox(width: kSpacingSM),
                          Text(
                            label,
                            style: TextStyle(
                              color: color,
                              fontSize: kTextM,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kSpacingXXXXS),
                            child: OutlinedIconTextButton(
                              onPressed: () => const RouteRoute().push(context),
                              label: 'Find route',
                              icon: const Icon(Icons.route_outlined),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kSpacingXS),
                        child: SafetyScale(rating: rating),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kSpacingSM),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: kTextXS,
                            color: kGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSizeBar * 10,
      height: kSizeBar,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(
          Radius.circular(kSizeBar),
        ),
      ),
    );
  }
}
