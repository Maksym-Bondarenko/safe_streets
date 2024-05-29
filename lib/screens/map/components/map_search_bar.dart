import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/screens/map/providers/map_search.dart';

// onBack - close keyboard
// onLoad - show Spinner
// onType - get debounced search results
// onClick - set marker + center map + prefill search bar text + close search bar
// onClose - close search bar + remove marker
// onSearch - search again + show list

// TODO check if stateless widget works as well
class MapSearchBar extends ConsumerStatefulWidget {
  const MapSearchBar({super.key});

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
  final _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      viewBackgroundColor: kWhite,
      viewSurfaceTintColor: kWhite,
      dividerColor: kGrey,
      builder: (context, controller) => SearchBar(
        controller: controller,
        constraints: const BoxConstraints(),
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kRadiusS)),
        )),
        textStyle: const MaterialStatePropertyAll(_textStyleSearchBar),
        surfaceTintColor: const MaterialStatePropertyAll(kWhite),
        backgroundColor: const MaterialStatePropertyAll(kWhite),
        onTap: controller.openView,
        onChanged: (value) async {
          print('## CHANGING: ${controller.text}');
          // ref.read(queryServiceProvider.notifier).searchForQuery(value);
          controller.openView();
        },
        leading: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: kSpacingS,
            horizontal: kSpacingSM,
          ),
          child: Icon(
            Icons.location_pin,
            color: kGrey,
            size: kIcon,
          ),
        ),
        trailing: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(vertical: kSpacingS, horizontal: kSpacingSM),
            icon: const Icon(
              Icons.search,
              color: kGrey,
              size: kIcon,
            ),
            // onPressed: () {
            //   ref(mapControlProvider)
            //   widget._onSubmit(controller.text);
            // },
            onPressed: () {
              // ref.read(mapControlProvider.notifier).centerOnCurrentPosition();
              // if (controller.text.isNotEmpty) {
              //   ref.read(placesServiceProvider.notifier).searchByText(controller.text);
              // }
            },
          ),
        ],
      ),
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) {
          // controller.closeView(null);
          return [];
        }

        ref.read(mapSearchQueryProvider.notifier).set(controller.text);
        final suggestions = await ref.watch(mapSearchAutocompleteProvider.future);

        print('## suggestions.length ${suggestions.length}');

        return suggestions.map(
          (suggestion) {
            final secondardText = suggestion.structuredFormat.secondaryText;

            return ListTile(
              title: Row(
                children: [
                  switch (suggestion) {
                    PlaceSuggestion() => const Text('P - '),
                    QuerySuggestion() => const Text('Q - '),
                  },
                  Expanded(
                    flex: 0,
                    child: Text(
                      suggestion.structuredFormat.mainText.text,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (secondardText != null) ...[
                    const Text(', '),
                    Expanded(
                      child: Text(
                        secondardText.text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ]
                ],
              ),
              onTap: () async {
                // final places = await placesService.searchByText(prediction.text.text);
                // final Location(:latitude, :longitude) = places.first.location;

                // controller.closeView(prediction.text.text);
                // print('## mSB - before centerOn');
                // print(places.first);
                // await mapControl.centerOn(latitude: latitude, longitude: longitude, zoom: 10);
                // print('## mSB - after centerOn');
              },
            );
          },
        );
      },
    );
  }
}

const _textStyleSearchBar = TextStyle(
  color: kBlack,
  fontSize: kTextXS,
  decorationThickness: 0,
);
