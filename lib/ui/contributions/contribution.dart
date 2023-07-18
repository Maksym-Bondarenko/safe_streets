import 'package:flutter/material.dart';

import '../../shared/points_types.dart';

/// Custom styling for a single contribution card
/// includes all information about contributed point (created or commented)
class ContributionCard extends StatelessWidget {
  final Contribution contribution;

  const ContributionCard({Key? key, required this.contribution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // set the right icon and title-color
    String icon;
    Color titleColor = Colors.blue;
    MapPoint mapPoint = RecommendationPoint.other;
    if (contribution.pointType == MainType.dangerPoint) {
      icon = DangerPoint.other.markerSrc;
      mapPoint = DangerPoint.other;
    } else if (contribution.pointType == MainType.recommendationPoint) {
      icon = RecommendationPoint.other.markerSrc;
      mapPoint = RecommendationPoint.other;
    } else {
      icon = SafePoint.police.markerSrc;
      mapPoint = SafePoint.police;
    }
    titleColor =
        Color.fromARGB(255, mapPoint.colorR, mapPoint.colorG, mapPoint.colorB);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  contribution.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.place,
                      color: Colors.blue,
                      size: 14.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      contribution.place,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(contribution.likes.toString()),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.comment,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(contribution.comments.toString()),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -8.0,
            right: -8.0,
            child: Image.asset(
              icon,
              width: 48.0,
              height: 48.0,
            ),
          ),
        ],
      ),
    );
  }
}

// wrapper-class for the contribution-card with all needed values
class Contribution {
  final String title;
  final String description;
  final String place;
  final int likes;
  final int comments;
  final MainType pointType;

  Contribution({
    required this.title,
    required this.description,
    required this.place,
    required this.likes,
    required this.comments,
    required this.pointType,
  });
}