import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/widgets/outlined_icon_text_button.dart';

class SafetyInfoSheet extends StatelessWidget {
  final String _locationName;
  final String _safetyLabel;
  final String _safetyDescription;
  final double _safetyRating;
  final Function() _onPressed;
  final Color _safetyColor;

  SafetyInfoSheet({
    Key? key,
    locationName,
    safetyLabel,
    safetyDescription,
    safetyRating,
    onPressed,
  })  : _locationName = locationName,
        _safetyLabel = safetyLabel,
        _safetyDescription = safetyDescription,
        _safetyRating = safetyRating,
        _onPressed = onPressed,
        _safetyColor = _getSafetyColor(safetyRating),
        super(key: key);

  static Color _getSafetyColor(double safetyRating) {
    if (safetyRating >= 4) {
      return kGreen;
    } else if (safetyRating >= 3) {
      return kOrange;
    } else if (safetyRating >= 2) {
      return kYellow;
    } else {
      return kRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        child: DraggableScrollableSheet(
          // TODO stop drag from hitting Bottom Tabs
          // TODO figure out dynamic sizes
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.4,
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
                      Center(
                        child: Container(
                          width: kBar * 10,
                          height: kBar,
                          margin: const EdgeInsets.symmetric(
                            vertical: kSpacingSM,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(kBar),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        _locationName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: kTextL),
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
                          const SizedBox(width: kSpacingS),
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
                      Divider(thickness: kRatingScale, color: _safetyColor),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacingSM),
                        child: Text(
                          _safetyDescription,
                          style:
                              const TextStyle(fontSize: kTextS, color: kGrey),
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
