import 'package:flutter/material.dart';

import 'package:safe_streets/constants.dart';

class MapSearchBar extends StatefulWidget {
  final void Function(String) _onSubmit;
  final void Function(String)? _onChange;
  final void Function()? _onOpenMenu;

  const MapSearchBar({
    Key? key,
    required void Function(String) onSubmit,
    void Function(String)? onChange,
    void Function()? onOpenMenu,
  })  : _onSubmit = onSubmit,
        _onChange = onChange,
        _onOpenMenu = onOpenMenu,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(kSpacingS)),
            ),
          ),
          // onTap: () {
          //   controller.openView();
          // },
          // onChanged: (_) {
          //   controller.openView();
          // },
          leading: IconButton(
            icon: const Icon(Icons.menu, color: kGrey),
            onPressed: widget._onOpenMenu,
          ),
          trailing: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, color: kGrey),
              onPressed: () {
                widget._onSubmit(controller.text);
              },
            ),
          ],
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(
          5,
          (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          },
        );
      },
    );
  }
}
