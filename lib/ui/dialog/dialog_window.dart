// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../infowindow/danger_point_details_model.dart';
//
// class DialogWindow extends StatefulWidget {
//   const DialogWindow({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _DialogWindow();
// }
//
// class _DialogWindow extends State<DialogWindow> {
//
// @override
// initState() {
//   // change map-icon from default to custom
//     addCustomIcon();
//   super.initState();
// }
//
// // Dialog Form
// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// final TextEditingController _titleController = TextEditingController();
// final TextEditingController _descriptionController = TextEditingController();
//
// // for default marker
// static BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
//
// // change default google-marker-icon to custom one
// void addCustomIcon() {
//   BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(), "lib/assets/images/ic_danger_point_marker.png")
//       .then(
//         (icon) {
//       setState(() {
//         markerIcon = icon;
//       });
//     },
//   );
// }
//
// // create a marker on the map
// Future<void> createCustomMarker(LatLng latLng, String title,
//     String description) async {
//   var latitude = latLng.latitude;
//   var longitude = latLng.longitude;
//   var markerId = "marker_$latitude-$longitude-$title";
//   // var infoWindowModel = DangerPointDetailsModel(
//   //     icon: "sos",
//   //     iconBackgroundColor: "red",
//   //     name: "name",
//   //     placeId: markerId,
//   //     vicinity: "vicinity",
//   //     distance: 10.0,
//   //     danger: 4.0);
//
//   setState(() {
//     customMarkers.add(Marker(
//       markerId: MarkerId(markerId),
//       position: LatLng(latitude, longitude),
//       infoWindow: InfoWindow(
//         title: title,
//         snippet: description,
//       ),
//       // infoWindow: infoWindowModel,
//       icon: markerIcon,
//     ));
//   });
// }
//
// @override
// Future build(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         bool? isChecked = false;
//         return StatefulBuilder(builder: (context, setState)
//         {
//           return AlertDialog(
//             title: const Text('Create Danger-Point'),
//             content: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller: _titleController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please, enter the title";
//                         }
//                         return null;
//                       },
//                       initialValue: "",
//                       decoration:
//                       const InputDecoration(hintText: "Enter the Title"),
//                     ),
//                     TextFormField(
//                       controller: _descriptionController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Please, enter the description";
//                         }
//                         return null;
//                       },
//                       initialValue: "",
//                       decoration: const InputDecoration(
//                           hintText: "Enter the Description"),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Flexible(
//                           child: Text(
//                             "Hereby I confirm the privacy policy and willing to publish entered information.",
//                             overflow: TextOverflow.visible,
//                           ),
//                         ),
//                         Checkbox(
//                             value: isChecked,
//                             onChanged: (checked) {
//                               setState(() {
//                                 isChecked = checked;
//                               });
//                             })
//                       ],
//                     )
//                   ],
//                 )),
//             actions: <Widget>[
//               InkWell(
//                 child: const Text('Submit'),
//                 onTap: () {
//                   if (_formKey.currentState!.validate() && isChecked!) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Adding a DangerPoint...')),
//                     );
//                     // create a DangerPoint with given data
//                     createCustomMarker(latLng, _titleController.value.text,
//                         _descriptionController.value.text);
//                     Navigator.of(context).pop();
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Something gone wrong...')),
//                     );
//                   }
//                 },
//               ),
//             ],
//           );
//         };
//       }
//   );
// }
// }