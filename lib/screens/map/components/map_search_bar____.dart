// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:safe_streets/constants.dart';
// import 'package:safe_streets/models/places.dart';
// import 'package:safe_streets/services/map.dart';
// import 'package:safe_streets/services/places.dart';
// import 'package:safe_streets/utils/debounce.dart';

// // onBack - close keyboard
// // onLoad - show Spinner
// // onType - get debounced search results
// // onClick - set marker + center map + prefill search bar text + close search bar
// // onClose - close search bar + remove marker
// // onSearch - search again + show list

// class MapSearchBar extends ConsumerStatefulWidget {
//   final void Function(String) _onSubmit;
//   final void Function(String)? _onChange;
//   final void Function()? _onOpenMenu;

//   const MapSearchBar({
//     super.key,
//     required void Function(String) onSubmit,
//     void Function(String)? onChange,
//     void Function()? onOpenMenu,
//   })  : _onSubmit = onSubmit,
//         _onChange = onChange,
//         _onOpenMenu = onOpenMenu;

//   @override
//   ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
// }

// // class _MapSearchBarState extends ConsumerState<MapSearchBar> {
// class _MapSearchBarState extends ConsumerState<MapSearchBar> {
//   // final _debounce = Debounce(const Duration(milliseconds: 500));
//   final _searchController = SearchController();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       ref.read(queryServiceProvider.notifier).searchForQuery(_searchController.text);
//     });
//   }

//   @override
//   void dispose() {
//     // _debounce.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
// //     ref.listen(queryServiceProvider, (_, suggestions) {
// //   _searchController.text = suggestions;
// // });
//     final suggestionsState = ref.watch(queryServiceProvider);
//     print('## msb - BUILDING ${suggestionsState.value}');
//     // print(
//     //     '## msb - isLoading: ${suggestionsState.isLoading} - isRefreshing: ${suggestionsState.isRefreshing} - isReloading: ${suggestionsState.isReloading}');

//     return SearchAnchor(
//       searchController: _searchController,
//       viewBackgroundColor: kWhite,
//       viewSurfaceTintColor: kWhite,
//       dividerColor: kGrey,
//       // builder: _searchBarBuilder,
//       // suggestionsBuilder: _buildSuggestions,
//       builder: (context, controller) => SearchBar(
//         controller: controller,
//         constraints: const BoxConstraints(),
//         padding: const MaterialStatePropertyAll(EdgeInsets.zero),
//         shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(kRadiusS)),
//         )),
//         textStyle: const MaterialStatePropertyAll(_textStyleSearchBar),
//         surfaceTintColor: const MaterialStatePropertyAll(kWhite),
//         backgroundColor: const MaterialStatePropertyAll(kWhite),
//         // onTap: controller.openView,
//         // onChanged: (value) async {
//         onChanged: (value) async {
//           print('## CHANGING: ${controller.text}');
//           controller.openView();
//           // final results = await ref.read(placesServiceProvider.notifier).autocomplete(query: controller.text);
//           // print(results.length);
//           // print(results.first);
//         },
//         leading: const Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: kSpacingS,
//             horizontal: kSpacingSM,
//           ),
//           child: Icon(
//             Icons.location_pin,
//             color: kGrey,
//             size: kIcon,
//           ),
//         ),
//         trailing: <Widget>[
//           IconButton(
//             padding: const EdgeInsets.symmetric(vertical: kSpacingS, horizontal: kSpacingSM),
//             icon: const Icon(
//               Icons.search,
//               color: kGrey,
//               size: kIcon,
//             ),
//             // onPressed: () {
//             //   ref(mapControlProvider)
//             //   widget._onSubmit(controller.text);
//             // },
//             onPressed: () {
//               ref.read(mapControlProvider.notifier).centerOnCurrentPosition();
//               // if (controller.text.isNotEmpty) {
//               //   ref.read(placesServiceProvider.notifier).searchByText(controller.text);
//               // }
//             },
//           ),
//         ],
//       ),
//       // suggestionsBuilder: (context, controller) =>
//       // if (controller.text.isEmpty) {
//       //   // controller.closeView(null);
//       //   return [];
//       // }

//       // if (!controller.isOpen) controller.openView();

//       // final mapControl = ref.read(mapControlProvider.notifier);
//       // final placesService = ref.read(placesServiceProvider.notifier);
//       // final predictions = await placesService.autocomplete(controller.text);

//       // return queryState.when(
//       //   data: (state) {
//       // viewBuilder: (suggestions) => Consumer(
//       //   builder: (_, ref, __) =>
//       //       ref.watch(queryServiceProvider).whenOrNull(
//       //             data: (suggestions) => ListView.builder(
//       //               itemCount: suggestions.length,
//       //               itemBuilder: (_, index) => ListTile(
//       //                 title: Text(suggestions[index].structuredFormat.mainText.text),
//       //                 onTap: () => _searchController.closeView(
//       //                   suggestions[index].structuredFormat.mainText.text,
//       //                 ),
//       //               ),
//       //             ),
//       //           ) ??
//       //       const SizedBox(),
//       // ),
//       suggestionsBuilder: (context, controller) => [
//         Consumer(
//           builder: (_, ref, __) =>
//               ref.watch(queryServiceProvider).whenOrNull(
//                     data: (suggestions) => ListView.builder(
//                       itemCount: suggestions.length,
//                       itemBuilder: (_, index) => ListTile(
//                         title: Text(suggestions[index].structuredFormat.mainText.text),
//                         onTap: () => _searchController.closeView(
//                           suggestions[index].structuredFormat.mainText.text,
//                         ),
//                       ),
//                     ),
//                   ) ??
//               const SizedBox(),
//         )
//       ],

//       // suggestionsBuilder: (context, controller) {
//       //   print('## msb - suggestionsBuilder ${suggestionsState.value?.length}');
//       //   // print(controller.);
//       //   // if (query.isEmpty) {
//       //   //   // controller.closeView(null);
//       //   //   return [];
//       //   // }

//       //   if (!controller.isOpen) controller.openView();

//       //   return suggestionsState.when(
//       //     data: (suggestions) => suggestions.map((suggestion) {
//       //       print('## msb - suggestions: ${suggestions.length}');
//       //       final secondardText = suggestion.structuredFormat.secondaryText;

//       //       return ListTile(
//       //         title: Row(
//       //           children: [
//       //             switch (suggestion) {
//       //               PlaceSuggestion() => const Text('P - '),
//       //               QuerySuggestion() => const Text('Q - '),
//       //             },
//       //             Expanded(
//       //               flex: 0,
//       //               child: Text(
//       //                 suggestion.structuredFormat.mainText.text,
//       //                 overflow: TextOverflow.ellipsis,
//       //               ),
//       //             ),
//       //             if (secondardText != null) ...[
//       //               Text(controller.text),
//       //               const Text(', '),
//       //               Expanded(
//       //                 child: Text(
//       //                   secondardText.text,
//       //                   overflow: TextOverflow.ellipsis,
//       //                   style: const TextStyle(color: Colors.grey),
//       //                 ),
//       //               ),
//       //             ]
//       //           ],
//       //         ),
//       //         onTap: () async {
//       //           // final places = await placesService.searchByText(prediction.text.text);
//       //           // final Location(:latitude, :longitude) = places.first.location;

//       //           // controller.closeView(prediction.text.text);
//       //           // print('## mSB - before centerOn');
//       //           // print(places.first);
//       //           // await mapControl.centerOn(latitude: latitude, longitude: longitude, zoom: 10);
//       //           // print('## mSB - after centerOn');
//       //         },
//       //       );
//       //     }),
//       //     error: (_, __) => [Text('error')],
//       //     loading: () => [Text('loading')],
//       //   );

//       // switch (suggestionsState) {
//       //   AsyncData(:final xx) => value.map((suggestion) {
//       //       print('## msb - suggestions: ${value.length}');
//       //       final secondardText = suggestion.structuredFormat.secondaryText;

//       //       return ListTile(
//       //         title: Row(
//       //           children: [
//       //             switch (suggestion) {
//       //               PlaceSuggestion() => const Text('P - '),
//       //               QuerySuggestion() => const Text('Q - '),
//       //             },
//       //             Expanded(
//       //               flex: 0,
//       //               child: Text(
//       //                 suggestion.structuredFormat.mainText.text,
//       //                 overflow: TextOverflow.ellipsis,
//       //               ),
//       //             ),
//       //             if (secondardText != null) ...[
//       //               const Text(', '),
//       //               Expanded(
//       //                 child: Text(
//       //                   secondardText.text,
//       //                   overflow: TextOverflow.ellipsis,
//       //                   style: const TextStyle(color: Colors.grey),
//       //                 ),
//       //               ),
//       //             ]
//       //           ],
//       //         ),
//       //         onTap: () async {
//       //           // final places = await placesService.searchByText(prediction.text.text);
//       //           // final Location(:latitude, :longitude) = places.first.location;

//       //           // controller.closeView(prediction.text.text);
//       //           // print('## mSB - before centerOn');
//       //           // print(places.first);
//       //           // await mapControl.centerOn(latitude: latitude, longitude: longitude, zoom: 10);
//       //           // print('## mSB - after centerOn');
//       //         },
//       //       );
//       //     }),
//       //   // TODO: Handle this case.
//       //   AsyncError(:final error) => [Center(child: Text('Error $error'))],
//       //   _ => const [Center(child: CircularProgressIndicator())],
//       //   // AsyncValue<List<Suggestion>>() => null,
//       // };
//       // error: (_, __) => [],
//       // loading: () => [],
//       // },
//     );
//   }
// }

// // Widget _searchBarBuilder(
// //   BuildContext context,
// //   SearchController controller,
// // ) {
// //   return SearchBar(
// //     controller: controller,
// //     constraints: const BoxConstraints(),
// //     padding: const MaterialStatePropertyAll(EdgeInsets.zero),
// //     shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
// //       borderRadius: BorderRadius.all(Radius.circular(kRadiusS)),
// //     )),
// //     textStyle: const MaterialStatePropertyAll(_textStyleSearchBar),
// //     surfaceTintColor: const MaterialStatePropertyAll(kWhite),
// //     backgroundColor: const MaterialStatePropertyAll(kWhite),
// //     // onTap: controller.openView,
// //     // onChanged: (value) async {
// //     onChanged: (value) async {
// //       print('## CHANGING: ${controller.text}');
// //       controller.openView();
// //       // final results = await ref.read(placesServiceProvider.notifier).autocomplete(query: controller.text);
// //       // print(results.length);
// //       // print(results.first);
// //     },
// //     leading: const Padding(
// //       padding: EdgeInsets.symmetric(
// //         vertical: kSpacingS,
// //         horizontal: kSpacingSM,
// //       ),
// //       child: Icon(
// //         Icons.location_pin,
// //         color: kGrey,
// //         size: kIcon,
// //       ),
// //     ),
// //     trailing: <Widget>[
// //       IconButton(
// //         padding: const EdgeInsets.symmetric(vertical: kSpacingS, horizontal: kSpacingSM),
// //         icon: const Icon(
// //           Icons.search,
// //           color: kGrey,
// //           size: kIcon,
// //         ),
// //         // onPressed: () {
// //         //   ref(mapControlProvider)
// //         //   widget._onSubmit(controller.text);
// //         // },
// //         onPressed: () {
// //           ref.read(mapControlProvider.notifier).centerOnCurrentPosition();
// //           // if (controller.text.isNotEmpty) {
// //           //   ref.read(placesServiceProvider.notifier).searchByText(controller.text);
// //           // }
// //         },
// //       ),
// //     ],
// //   );
// // }

// // FutureOr<Iterable<Widget>> _buildSuggestions(
// //   BuildContext context,
// //   SearchController controller,
// // ) async {
// //   if (controller.text.isEmpty) {
// //     // controller.closeView(null);
// //     return [];
// //   }

// //   if (!controller.isOpen) controller.openView();

// //   final mapControl = ref.read(mapControlProvider.notifier);
// //   final placesService = ref.read(placesServiceProvider.notifier);
// //   final queryState = ref.watch(queryServiceProvider);
// //   final predictions = await placesService.autocomplete(controller.text);

// //   return predictions.map((prediction) {
// //     final secondardText = prediction.structuredFormat.secondaryText;

// //     return queryState.when(data:
// //     , error: error, loading: loading,);

// //     return ListTile(
// //       title: Row(
// //         children: [
// //           switch (prediction) {
// //             PlacePrediction() => const Text('P - '),
// //             QueryPrediction() => const Text('Q - '),
// //           },
// //           Expanded(
// //             flex: 0,
// //             child: Text(
// //               prediction.structuredFormat.mainText.text,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ),
// //           if (secondardText != null) ...[
// //             const Text(', '),
// //             Expanded(
// //               child: Text(
// //                 secondardText.text,
// //                 overflow: TextOverflow.ellipsis,
// //                 style: const TextStyle(color: Colors.grey),
// //               ),
// //             ),
// //           ]
// //         ],
// //       ),
// //       onTap: () async {
// //         final places = await placesService.searchByText(prediction.text.text);
// //         final Location(:latitude, :longitude) = places.first.location;

// //         controller.closeView(prediction.text.text);
// //         print('## mSB - before centerOn');
// //         print(places.first);
// //         await mapControl.centerOn(latitude: latitude, longitude: longitude, zoom: 10);
// //         print('## mSB - after centerOn');
// //       },
// //     );
// //   });
// // }
// // }

// const _textStyleSearchBar = TextStyle(
//   color: kBlack,
//   fontSize: kTextXS,
//   decorationThickness: 0,
// );
