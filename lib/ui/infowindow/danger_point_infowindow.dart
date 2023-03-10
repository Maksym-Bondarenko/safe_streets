import 'package:flutter/material.dart';

class DangerPointInfoWindow extends StatefulWidget {
  final String title;
  final String description;

  DangerPointInfoWindow(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  _DangerPointInfoWindowState createState() => _DangerPointInfoWindowState();
}

class _DangerPointInfoWindowState extends State<DangerPointInfoWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.red,
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 0))
                  ]),
              child: const ClipRRect(
                  child: CircleAvatar(
                radius: 5.0,
                backgroundImage:
                    AssetImage("lib/assets/images/location_marker.png"),
              )),
            ),
            const SizedBox(height: 10.0),
            Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                elevation: 5.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(widget.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.redAccent))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2.0),
                          child: Text(widget.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )))
                    ])),
          ])),
    );
  }
}
