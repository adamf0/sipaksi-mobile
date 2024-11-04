import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/CustomBadge/CustomBadge.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/DropdownSearch/ItemsDropdownSearch.dart';

class DropdownSearch extends StatefulWidget {
  final ValueNotifier<List<DropdownItems>> badgesNotifier;
  final ValueNotifier<List<DropdownItems>> filteredNotifier;
  final Future<void> Function(String query) fetchUsers;
  final Function()? eventChange;

  const DropdownSearch({
    Key? key,
    required this.badgesNotifier,
    required this.filteredNotifier,
    required this.fetchUsers,
    this.eventChange,
  }) : super(key: key);

  @override
  _DropdownSearchState createState() => _DropdownSearchState();
}

class _DropdownSearchState extends State<DropdownSearch> {
  final FocusNode _focusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    widget.fetchUsers("");
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
        FocusScope.of(context).requestFocus(_focusNode);
        print("focus: ${_focusNode.hasFocus}");
        _showBottomSheet(context);
      },
      child: ValueListenableBuilder<List<dynamic>>(
        valueListenable: widget.badgesNotifier,
        builder: (context, badges, child) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: widget.badgesNotifier.value
                        .map(
                          (badge) => CustomBadge(
                            label: badge.text,
                            onRemove: () {
                              widget.badgesNotifier.value = [
                                ...widget.badgesNotifier.value
                              ]..remove(badge);
                              widget.eventChange?.call();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                AnimatedRotation(
                  turns: _focusNode.hasFocus ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (contextSheet) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          widthFactor: 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                CloseBottomSheet(ctx: contextSheet),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: TextInputType.text,
                          onChanged: (query) {
                            _debouncer.run(() {
                              widget.fetchUsers(query);
                            });
                          },
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(contextSheet).colorScheme.outline,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.outline),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<List<DropdownItems>>(
                          valueListenable: widget.filteredNotifier,
                          builder: (context, filtered, child) {
                            String filter =
                                widget.badgesNotifier.value.length == 1
                                    ? widget.badgesNotifier.value.first.key
                                    : "";

                            return Expanded(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  var selected = filtered[index];
                                  bool isDisabled = filter == selected.key;

                                  return GestureDetector(
                                    onTap: () {
                                      if (!isDisabled) {
                                        widget.badgesNotifier.value = [
                                          selected,
                                        ];
                                        widget.eventChange?.call();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Opacity(
                                      opacity: !isDisabled ? 1.0 : 0.3,
                                      child: ItemsDropdownSearch(
                                        item: selected,
                                        padding: EdgeInsets.fromLTRB(
                                            8, index == 0 ? 8 : 0, 8, 8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    //masih gagal deteksi masih terbuka atau tidak si modalnya
    // if (result != null) {
    //   print("modal dibuka");
    // } else {
    //   print("modal ditutup");
    //   _focusNode.unfocus();
    // }
  }
}
