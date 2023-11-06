import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

Color getSafetyColor(double safetyRating) {
  if (safetyRating >= 4) {
    return kGreen;
  } else if (safetyRating >= 3) {
    return kYellow;
  } else if (safetyRating >= 2) {
    return kOrange;
  } else if (safetyRating >= 1) {
    return kRed;
  } else {
    return kGrey;
  }
}

String getSafetyLabel(double safetyRating) {
  if (safetyRating >= 4) {
    return 'Safe';
  } else if (safetyRating >= 3) {
    return 'Mostly safe';
  } else if (safetyRating >= 2) {
    return 'Not very safe';
  } else if (safetyRating >= 1) {
    return 'Unsafe';
  } else {
    return '--';
  }
}
