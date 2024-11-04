import 'package:sipaksi/Module/Shared/LoadingStrategy.dart';

class LoadingManager<T> {
  final LoadingStrategy<T> loadingStrategy;

  LoadingManager(this.loadingStrategy);

  bool get stateLoading => loadingStrategy.output();
}
