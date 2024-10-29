import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/FetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/FilterStrategy.dart';

class AnggotaPenelitianManager<T> {
  late Future<List<T>> dataFuture;
  List<T> allData = [];
  ValueNotifier<List<T>> filteredData = ValueNotifier<List<T>>([]);
  String searchTerm = "";
  List<T?> selectedItems = [];
  final FetchStrategy<T> fetchStrategy;
  final FilterStrategy<T> filterStrategy;

  AnggotaPenelitianManager(this.fetchStrategy, this.filterStrategy) {
    dataFuture = fetchData();
  }

  Future<List<T>> fetchData() async {
    allData = await fetchStrategy.fetchData();
    filteredData.value = allData;
    return allData;
  }

  void updateSearchTerm(String term) {
    searchTerm = term;
    filteredData.value = filterStrategy.filterData(allData, searchTerm);
  }
}
