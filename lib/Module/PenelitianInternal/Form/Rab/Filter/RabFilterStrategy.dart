import 'package:sipaksi/Module/PenelitianInternal/Form/Share/FilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';

class RabFilterStrategy implements FilterStrategy<Post> {
  @override
  List<Post> filterData(List<Post> posts, String searchTerm) {
    final lowerCaseTerm = searchTerm.toLowerCase();
    return posts.where((post) {
      return (post.albumId?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.id?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.title?.toLowerCase().contains(lowerCaseTerm) ?? false) ||
          (post.url?.toLowerCase().contains(lowerCaseTerm) ?? false) ||
          (post.thumbnailUrl?.toLowerCase().contains(lowerCaseTerm) ?? false);
    }).toList();
  }
}
