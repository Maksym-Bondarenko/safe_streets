import 'package:flutter/material.dart';
import 'package:safe_streets/shared/points_types.dart';

class PointInfoWindow extends StatefulWidget {
  final MainType mainType;
  final MapPoint subType;
  final String title;
  final String description;
  late int votes;

  PointInfoWindow(
      {Key? key,
      required this.mainType,
      required this.subType,
      required this.title,
      required this.description,
      required this.votes})
      : super(key: key);

  @override
  _PointInfoWindowState createState() => _PointInfoWindowState();
}

class _PointInfoWindowState extends State<PointInfoWindow> with SingleTickerProviderStateMixin {

  late Color mainColor;
  // for animation of the icon
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    mainColor = Color.fromRGBO(widget.subType.colorR, widget.subType.colorG,
        widget.subType.colorB, 1.0);

    // initialise the animation controller (for point-icon)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

  }

  // animate (zoom-in, zoom-out) the point-icon
  void _animateIcon() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _decrementVotes() {
    setState(() {
      widget.votes--;
      _saveVotes();
    });
  }

  void _incrementVotes() {
    setState(() {
      widget.votes++;
      _saveVotes();
    });
  }

  void _saveVotes() {
    // TODO: Add your code here to save the votes to the backend
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: _animateIcon,
        child: Column(
          children: <Widget>[
            _buildPointIcon(),
            const SizedBox(height: 5.0),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  // Icon of Point (according to the type and sub-type)
  Widget _buildPointIcon() {
    return Container(
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
    );
  }

  // Main Body of InfoWindow
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
          Text(
            widget.mainType.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: mainColor,
            ),
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
        IconButton(
          onPressed: _decrementVotes,
          icon: const Icon(Icons.remove),
          color: Colors.black,
          iconSize: 15,
        ),
        Text(
          'Total votes: ${widget.votes}',
          style: const TextStyle(fontSize: 10),
        ),
        IconButton(
          onPressed: _incrementVotes,
          icon: const Icon(Icons.add),
          color: Colors.black,
          iconSize: 15,
        ),
      ],
    );
  }
}
