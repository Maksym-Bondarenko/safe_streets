import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:safe_streets/constants.dart';
import 'package:safe_streets/models/places.dart';
import 'package:safe_streets/screens/map/providers/map_controller.dart';
import 'package:safe_streets/screens/map/providers/map_search.dart';
import 'package:safe_streets/screens/map/providers/selected_place.dart';

class MapSearchBar extends HookConsumerWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBeenCleared = useState(false);
    final focusNode = useFocusScopeNode();
    final searchController = useSearchController();
    final selectedPlaceNotifier = ref.read(selectedPlaceProvider.notifier);
    final mapSearchResultNotifier = ref.read(mapSearchResultsProvider.notifier);
    ref.watch(mapSearchResultsProvider);

    void closeView([String? query]) {
      searchController.closeView(query);
      hasBeenCleared.value = true;
      FocusScope.of(context).unfocus();
    }

    void clearResultsAndSelection() {
      selectedPlaceNotifier.clear();
      mapSearchResultNotifier.clear();
    }

    void clearSearch() {
      clearResultsAndSelection();
      searchController.clear();
    }

    return FocusScope(
      node: focusNode,
      onFocusChange: (isFocused) {
        if (hasBeenCleared.value && isFocused) {
          hasBeenCleared.value = false;
          focusNode.unfocus();
        }
      },
      child: SearchAnchor(
        viewLeading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: closeView,
        ),
        searchController: searchController,
        viewBackgroundColor: kWhite,
        viewSurfaceTintColor: kWhite,
        viewOnSubmitted: (query) {
          mapSearchResultNotifier.searchByQuery(query);
          closeView();
        },
        viewOnChanged: (query) => clearResultsAndSelection(),
        dividerColor: kGrey,
        builder: (context, controller) => SearchBar(
          controller: controller,
          constraints: const BoxConstraints(),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: const WidgetStatePropertyAll(_shapeSearchBar),
          textStyle: const WidgetStatePropertyAll(_textStyleSearchBar),
          surfaceTintColor: const WidgetStatePropertyAll(kWhite),
          backgroundColor: const WidgetStatePropertyAll(kWhite),
          onTap: controller.openView,
          leading: Padding(
            padding: const EdgeInsets.only(left: kSpacingXXXS),
            child: IconButton(
              icon: const Icon(Icons.location_pin, color: kGrey, size: kSizeIcon),
              onPressed: ref.read(mapControllerProvider.notifier).centerOnSelectedPlace,
            ),
          ),
          trailing: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: clearSearch,
              )
          ],
        ),
        suggestionsBuilder: (context, controller) async {
          final suggestions = await ref.read(mapSearchAutocompleteProvider(searchController.text).future);
          return suggestions.map(
            (suggestion) => _Suggestion(
              suggestion: suggestion,
              onTap: () {
                selectedPlaceNotifier.setBySuggestion(suggestion);
                closeView(suggestion.text.text);
              },
            ),
          );
        },
      ),
    );
  }
}

class _Suggestion extends StatelessWidget {
  final Suggestion suggestion;
  final void Function()? onTap;

  const _Suggestion({required this.suggestion, this.onTap});

  @override
  Widget build(BuildContext context) {
    final mainText = suggestion.structuredFormat.mainText.text;
    final secondardText = suggestion.structuredFormat.secondaryText?.text;
    return ListTile(
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Text(
                  mainText,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (secondardText != null)
                Expanded(
                  child: Text(
                    ', $secondardText',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          );
        },
      ),
      onTap: onTap,
    );
  }
}

const _textStyleSearchBar = TextStyle(
  color: kBlack,
  fontSize: kTextXS,
  decorationThickness: 0,
);

const _shapeSearchBar = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kRadiusS)));
