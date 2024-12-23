import 'package:sipaksi/Module/PenelitianInternal/Form/Share/FilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';

class NonDosenFilterStrategy implements FilterStrategy<Post> {
  @override
  List<Post> filterData(List<Post> posts, String searchTerm) {
    final lowerCaseTerm = searchTerm.toLowerCase();
    return posts.where((post) {
      return (post.albumId?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.id?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.title?.toLowerCase().contains(lowerCaseTerm) ?? false);
    }).toList();
  }
}
