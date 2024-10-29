abstract class FetchStrategy<T> {
  Future<List<T>> fetchData();
}
