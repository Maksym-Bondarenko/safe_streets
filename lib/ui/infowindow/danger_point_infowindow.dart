import 'package:flutter/material.dart';
import 'package:safe_streets/ui/infowindow/points_types.dart';

class DangerPointInfoWindow extends StatefulWidget {
  final DangerPoints pointType;
  final String title;
  final String description;

  DangerPointInfoWindow(
      {Key? key,
      required this.pointType,
      required this.title,
      required this.description})
      : super(key: key);

  @override
  _DangerPointInfoWindowState createState() => _DangerPointInfoWindowState();
}

class _DangerPointInfoWindowState extends State<DangerPointInfoWindow> {
  late DangerPoints point;
  late Color mainColor;

  // TODO: adjust coloring and icon according to pointType

  @override
  void initState() {
    super.initState();
    point = widget.pointType;
    mainColor = Color.fromRGBO(point.colorR, point.colorG, point.colorB, 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: mainColor,
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: const Offset(0, 0))
                ]),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: point.icon),
          ),
          const SizedBox(height: 5.0),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              minWidth: 200,
            ),
            child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                elevation: 5.0,
                surfaceTintColor: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(widget.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.red))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          child: Text(widget.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )))
                    ])),
          ),
        ]));
  }
}
