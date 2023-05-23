// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PathSearch extends StatefulWidget {
//   const PathSearch({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _PathSearch();
// }
//
// class _PathSearch extends State<PathSearch> {
//
//   // TODO: write functionality to widget for path-search between two geopoints
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 10.0,
//       right: 15.0,
//       left: 15.0,
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 50.0,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Colors.white,
//             ),
//             child: Column(
//               children: <Widget>[
//                 TextField(
//                   decoration: const InputDecoration(
//                     hintText: 'Enter the place',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.only(
//                       left: 15.0,
//                       top: 15.0
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.search),
//                       iconSize: 30.0,
//                       onPressed: () {},
//                     )
//                   ),
//                   controller: placeController,
//                   onTap: () async {
//                     Prediction p = await PlacesAutocomplete.show(
//                       context: context,
//                       apiKey: apiKey,
//                       mode: Mode.overlay,
//                       language: "en",
//                       components: [
//                         new Component(component.country, "en")
//                       ]
//                     );
//                     displayPrediction(p);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }