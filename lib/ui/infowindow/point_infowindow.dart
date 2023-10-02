import 'package:flutter/material.dart';
import 'package:safe_streets/services/manual_points_service.dart';
import 'package:safe_streets/shared/points_types.dart';

/// Info-Window of a Point-Marker
/// including point-type, subtype, title, description, icon and votes
class PointInfoWindow extends StatefulWidget {
  final String pointId;
  final MainType mainType;
  final MapPoint subType;
  final String title;
  final String description;
  late int votes;

  PointInfoWindow({
    Key? key,
    required this.pointId,
    required this.mainType,
    required this.subType,
    required this.title,
    required this.description,
    required this.votes,
  }) : super(key: key);

  @override
  _PointInfoWindowState createState() => _PointInfoWindowState();
}

class _PointInfoWindowState extends State<PointInfoWindow> {
  late ManualPointsService pointsService = ManualPointsService();

  // TODO: fetch initial value from backend
  late Color mainColor;
  // Maintain toggle states for action buttons
  bool markToggled = false;
  bool muteToggled = false;
  bool forwardToggled = false;
  bool hideToggled = false;
  String imagePath = 'lib/assets/images/';
  late List<Comment> comments;

  @override
  void initState() {
    super.initState();
    setState(() {
      // set color according to the point-type
      mainColor = Color.fromRGBO(widget.subType.colorR, widget.subType.colorG,
          widget.subType.colorB, 1.0);
      _fetchComments();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _decrementVotes() {
    setState(() {
      widget.votes--;
      _saveVotes(Voting.devote);
    });
  }

  void _incrementVotes() {
    setState(() {
      widget.votes++;
      _saveVotes(Voting.upvote);
    });
  }

  void _saveVotes(Voting vote) {
    pointsService.voteOnPoint(widget.pointId, vote);
    // todo: disable new voting on points (only un-voting)
  }

  Future<void> _fetchComments() async {
    comments = <Comment>[
      Comment('${imagePath}logo_small.png', 'John', 'This is a great place!'),
      Comment('${imagePath}logo_small.png', 'Emma', 'I love this spot.'),
      Comment('${imagePath}logo_small.png', 'Eve', 'Do not go there!'),
    ];
  }

  void _markFunction() {
    // TODO: Implement the logic for the 'Mark' badge
  }

  void _muteFunction() {
    // TODO: Implement the logic for the 'Mute' badge
  }

  void _forwardFunction() {
    // TODO: Implement the logic for the 'Forward' badge
  }

  void _hideFunction() {
    // TODO: Implement the logic for the 'Hide' badge
  }

  void _deletePoint() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              // Drag handle
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 4.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // main part includes title, votes, description
                      _buildMainPart(),

                      // action part includes scrollable button-badges
                      _buildActionPart(),

                      // comment part includes comments to the point
                      _buildCommentsPart(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // point-type, title, voting and description
  Widget _buildMainPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: mainColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: _incrementVotes,
                    child: const Icon(Icons.thumb_up_outlined),
                  ),
                  const SizedBox(width: 8),
                  const Text('100'),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: _decrementVotes,
                    child: const Icon(Icons.thumb_down_outlined),
                  ),
                  const SizedBox(width: 8),
                  const Text('20'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          scrollDirection: Axis.vertical,
          child: Text(
            widget.description,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // row of action toggle-buttons to the selected point
  Widget _buildActionPart() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget> [
              _buildToggleBadge(
                text: 'Mark',
                toggleText: 'Unmark',
                icon: Icons.star,
                toggledIcon: Icons.star_outline,
                toggled: markToggled,
                onTap: () {
                  setState(() {
                    markToggled = !markToggled;
                  });
                  _markFunction();
                },
              ),
              _buildToggleBadge(
                text: 'Mute',
                toggleText: 'Unmute',
                icon: Icons.notifications_off,
                toggledIcon: Icons.notifications,
                toggled: muteToggled,
                onTap: () {
                  setState(() {
                    muteToggled = !muteToggled;
                  });
                  _muteFunction();
                },
              ),
              _buildToggleBadge(
                text: 'Hide',
                toggleText: 'Unhide',
                icon: Icons.visibility,
                toggledIcon: Icons.visibility_off,
                toggled: hideToggled,
                onTap: () {
                  setState(() {
                    hideToggled = !hideToggled;
                  });
                  _hideFunction();
                },
              ),
              GestureDetector(
                onTap: _deletePoint,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            Text('Delete', style: TextStyle(color: Colors.white, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // element of toggle-badge that changes the visual by toggling it
  Widget _buildToggleBadge({
    required String text,
    required String toggleText,
    required IconData icon,
    required IconData toggledIcon,
    required bool toggled,
    required VoidCallback onTap,
  }) {
    String badgeText = toggled ? toggleText : text;
    Color badgeColor = toggled ? Colors.teal : Colors.grey;
    IconData badgeIcon = toggled ? toggledIcon : icon;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                children: [
                  Icon(badgeIcon, color: Colors.white),
                  Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // section with comments: top-comments and button to show all
  Widget _buildCommentsPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var comment in comments)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(comment.userImage),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.text.length > 30
                                ? '${comment.text.substring(0, 30)}...' // Truncate long comments
                                : comment.text,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
            'See All Comments',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
    ),
        ),
      ],
    );
  }
}

class Comment {
  final String userImage;
  final String userName;
  final String text;

  Comment(this.userImage, this.userName, this.text);
}
