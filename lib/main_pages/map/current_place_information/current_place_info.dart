import 'package:flutter/material.dart';

/// Component with current information about user's position with safety-rating
class CurrentPlaceInfo extends StatefulWidget {
  final String place;
  final double safetyIndex;
  final String overview;

  const CurrentPlaceInfo({
    super.key,
    required this.place,
    required this.safetyIndex,
    required this.overview,
  });

  @override
  _CurrentPlaceInfoState createState() => _CurrentPlaceInfoState();
}

class _CurrentPlaceInfoState extends State<CurrentPlaceInfo> {
  // add additional attributes and functions
  // (e.g. get color based on safety-index)

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // place-name
              Row(
                children: [
                  Text(widget.place),
                ],
              ),

              // safety-index and button
              Row(
                children: [
                  Text("${widget.safetyIndex} + /5"),
                  Text("Unsafe"),
                  InkWell(
                    onTap: () => print("add place clicked"),
                  ),
                ],
              ),

              // place-info
              Text("bla-bla-bla ..."),
            ],
          ),
        ),
      ),
    );
  }
}
