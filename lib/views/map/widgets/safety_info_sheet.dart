import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/safety_info.dart';
import 'package:safe_streets/views/map/widgets/safety_scale.dart';
import 'package:safe_streets/widgets/outlined_icon_text_button.dart';

class SafetyInfoSheet extends StatelessWidget {
  final String _locationName;
  final double _safetyRating;
  final String _safetyLabel;
  final String _safetyDescription;
  final Color _safetyColor;
  final void Function() _onPressed;

  SafetyInfoSheet({
    super.key,
    String? locationName,
    SafetyInfo? safetyInfo,
    Function()? onPressed,
  })  : _locationName = locationName ?? '----',
        _safetyRating = safetyInfo?.rating ?? 0,
        _safetyLabel = safetyInfo?.label ?? '--',
        _safetyDescription = safetyInfo?.description ?? '',
        _safetyColor = safetyInfo?.color ?? kGrey,
        _onPressed = onPressed ?? (() {});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kSpacingM),
                  topRight: Radius.circular(kSpacingM),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacingXXS),
                        child: Text(
                          _locationName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: kTextL),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _safetyRating.toStringAsFixed(1),
                            style: TextStyle(
                                color: _safetyColor, fontSize: kTextML),
                          ),
                          const Text(
                            '/5',
                            style: TextStyle(fontSize: kTextML, color: kGrey),
                          ),
                          const SizedBox(width: kSpacingSM),
                          Text(
                            _safetyLabel,
                            style: TextStyle(
                              color: _safetyColor,
                              fontSize: kTextML,
                            ),
                          ),
                          const Spacer(),
                          OutlinedIconTextButton(
                            onPressed: _onPressed,
                            label: 'Find route',
                            icon: const Icon(Icons.route_outlined),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacingXS),
                        child: SafetyScale(rating: _safetyRating),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacingSM),
                        child: Text(
                          _safetyDescription,
                          style: const TextStyle(
                            fontSize: kTextS,
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
  const _BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kBar * 10,
      height: kBar,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(
          Radius.circular(kBar),
        ),
      ),
    );
  }
}
