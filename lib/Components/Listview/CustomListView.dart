import 'package:flutter/material.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/ItemListStrategy.dart';

class CustomListView<T> extends StatelessWidget {
  final double width;
  final double height;
  final Future<List<T>> source;
  final ValueNotifier<List<T>> filteredData;
  final Function(T) onSelectedChanged;
  final List<T?> selectedItems;
  final ItemListStrategy<T> itemListStrategy;

  const CustomListView({
    Key? key,
    required this.width,
    required this.height,
    required this.source,
    required this.filteredData,
    required this.onSelectedChanged,
    required this.selectedItems,
    required this.itemListStrategy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: source,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenterLoadingComponent();
        } else if (snapshot.hasError) {
          return ErrorComponent(
            height: MediaQuery.of(context).size.height,
            errorMessage: snapshot.error.toString(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return DataNotFoundComponent(
              width: MediaQuery.of(context).size.width);
        } else {
          return ValueListenableBuilder<List<T>>(
            valueListenable: filteredData,
            builder: (context, filteredItems, child) {
              return ListView.builder(
                itemCount: filteredItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isSelected = selectedItems.contains(item);
                  return itemListStrategy.buildTile(
                    context,
                    item,
                    isSelected,
                    onSelectedChanged,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
