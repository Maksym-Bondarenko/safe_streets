import 'package:flutter/material.dart';

import 'package:safe_streets/models/point.dart';

/// Info-Window of a Point-Marker
/// including point-type, subtype, title, description, icon and votes
class PointInfoWindow extends StatefulWidget {
  final Point point;

  const PointInfoWindow({
    super.key,
    required this.point,
  });

  @override
  State<StatefulWidget> createState() => _PointInfoWindowState();
}

class _PointInfoWindowState extends State<PointInfoWindow>
    with SingleTickerProviderStateMixin {
  // for animation of the icon
  late AnimationController _animationController;
  int votes = 0;

  @override
  void initState() {
    super.initState();
    // initialise the animation controller (for point-icon)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform.scale(
                scale: 1.0 - _animationController.value * 0.2,
                child: child,
              ),
              child: GestureDetector(
                onTap: _animateIcon,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: widget.point.type.color,
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image(
                      image: AssetImage(widget.point.type.markerImagePath),
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              elevation: 10.0,
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.point.type.mainType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: widget.point.type.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              widget.point.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: widget.point.type.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              widget.point.description ?? '',
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decrementVotes,
                          icon: const Icon(Icons.remove),
                          color: Colors.black,
                          iconSize: 15,
                        ),
                        Text(
                          'Total votes: $votes',
                          style: const TextStyle(fontSize: 10),
                        ),
                        IconButton(
                          onPressed: _incrementVotes,
                          icon: const Icon(Icons.add),
                          color: Colors.black,
                          iconSize: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      votes--;
      _saveVotes();
    });
  }

  void _incrementVotes() {
    setState(() {
      votes++;
      _saveVotes();
    });
  }

  void _saveVotes() {
    // TODO: Add code here to save the votes to the backend
  }
}
