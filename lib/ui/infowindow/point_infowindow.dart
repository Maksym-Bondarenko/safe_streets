import 'package:flutter/material.dart';
import 'package:safe_streets/ui/infowindow/points_types.dart';

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

class _PointInfoWindowState extends State<PointInfoWindow> {
  late MainType mainType;
  late MapPoint subType;
  late Color mainColor;

  @override
  void initState() {
    super.initState();
    mainType = widget.mainType;
    subType = widget.subType;
    mainColor =
        Color.fromRGBO(subType.colorR, subType.colorG, subType.colorB, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  boxShadow: [
                    BoxShadow(
                        color: mainColor,
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: const Offset(0, 0))
                  ]),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image(
                    image: AssetImage(subType.markerSrc),
                    width: 80,
                    height: 80,
                  )),
            ),
            const SizedBox(height: 5.0),
            Card(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                elevation: 10.0,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mainType.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: mainColor)),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: mainColor)),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(widget.description,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => {setState(() => widget.votes--)},
                          icon: const Icon(Icons.remove),
                          color: Colors.black,
                          iconSize: 15,
                        ),
                        Text(
                          "Total votes: ${widget.votes}",
                          style: const TextStyle(fontSize: 10),
                        ),
                        IconButton(
                          onPressed: () => {setState(() => widget.votes++)},
                          icon: const Icon(Icons.add),
                          color: Colors.black,
                          iconSize: 15,
                        ),
                      ],
                    ),
                  ]),
                )),
          ])),
    );
  }
}
