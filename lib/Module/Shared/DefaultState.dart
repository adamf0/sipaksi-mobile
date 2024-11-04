import 'package:sipaksi/Module/Shared/LoadingStrategy.dart';

class DefaultState implements LoadingStrategy<bool> {
  final bool isLoading;

  DefaultState(this.isLoading);

  @override
  bool output() {
    return isLoading;
  }
}
