import 'package:flutter/material.dart';
import 'package:safe_streets/services/manual_points_service.dart';
import 'package:safe_streets/shared/points_types.dart';

import '../../shared/global_functions.dart';

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

class _PointInfoWindowState extends State<PointInfoWindow>
    with SingleTickerProviderStateMixin {
  late ManualPointsService pointsService = ManualPointsService();

  // TODO: fetch initial value from backend
  late bool notificationsEnabled = true;

  late Color mainColor;

  // for animation of the icon
  late AnimationController _animationController;

  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      mainColor = Color.fromRGBO(widget.subType.colorR, widget.subType.colorG,
          widget.subType.colorB, 1.0);

      // initialise the animation controller (for point-icon)
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  // animate (zoom-in, zoom-out) the point-icon
  void _animateIcon() async {
    await _animationController.forward();
    await _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  void _triggerNotifications() {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });
    // toaster-message
    String toastMessage = (notificationsEnabled)
        ? "Notifications were enabled"
        : "Notifications were disabled";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(toastMessage),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.blue),
    );

    // TODO: sent http put request to the backend
  }

  Future<List<dynamic>> _fetchComments() async {
    // TODO: call to backend
    // Implement the logic to fetch the comments
    // from the server or any other source
    // For now, we'll return a hardcoded list of comments

    // Simulating a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a list of dummy comments
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _animateIcon(), // Pass the BuildContext here
        child: Column(
          children: <Widget>[
            _buildPointIcon(context), // Pass the BuildContext here
            const SizedBox(height: 5.0),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  // Icon of Point (according to the type and sub-type)
  Widget _buildPointIcon(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - _animationController.value * 0.2,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _animateIcon,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              BoxShadow(
                color: mainColor,
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image(
              image: AssetImage(widget.subType.markerSrc),
              width: 80,
              height: 80,
            ),
          ),
        ),
      ),
    );
  }

  // Main Body of InfoWindow
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      elevation: 10.0,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            _buildMainType(),
            _buildTitle(),
            _buildDescription(),
            _buildVoteRow(),
            _buildCommentsSection()
          ],
        ),
      ),
    );
  }

  // Type Row
  Widget _buildMainType() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon showing if point was created by current user
          Visibility(
            visible: getUserId() == getCreatorIdOfPoint(widget.pointId),
            child: const InkWell(
              child: Tooltip(
                message: 'This point was created by you',
                child:
                    Icon(Icons.person_pin, color: Colors.blueAccent, size: 15),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            widget.mainType.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: mainColor,
            ),
          ),
          const SizedBox(width: 10.0),
          // enabling/disabling notifications on this point
          IconButton(
            onPressed: _triggerNotifications,
            icon: notificationsEnabled
                ? const Icon(Icons.notifications_on, color: Colors.green)
                : const Icon(Icons.notifications_off, color: Colors.red),
            iconSize: 15,
          ),
        ],
      ),
    );
  }

  //Title Row
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Description Area
  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              widget.description,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Vote Row
  Widget _buildVoteRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // decrement-vote button
        IconButton(
          onPressed: _decrementVotes,
          icon: const Icon(Icons.remove),
          color: Colors.black,
          iconSize: 15,
        ),
        // amount of votes
        Text(
          'Total votes: ${widget.votes}',
          style: const TextStyle(fontSize: 10),
        ),
        // increment-vote button
        IconButton(
          onPressed: _incrementVotes,
          icon: const Icon(Icons.add),
          color: Colors.black,
          iconSize: 15,
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            // Fetch comments from the server or any other source
            _fetchComments().then((commentList) {
              // Update the comments list and rebuild the widget
              setState(() {
                comments = commentList;
              });
            });
          },
          icon: const Icon(Icons.comment),
          color: Colors.black,
          iconSize: 15,
        ),
        Text(
          'Total comments: ${comments.length}',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );

    // return Column(
    //   children: [
    //     for (var comment in comments)
    //       ListTile(
    //         title: Text(comment.message),
    //         subtitle: Text(
    //           'Author: ${comment.author}\nDate: ${comment.date.toString()}',
    //         ),
    //       ),
    //   ],
    // );
  }
}
