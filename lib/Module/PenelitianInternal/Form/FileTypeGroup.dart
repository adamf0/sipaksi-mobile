enum FileTypeGroup {
  image(['jpg', 'jpeg', 'png', 'bmp']),
  document(['pdf', 'doc', 'docx']),
  presentation(['ppt', 'pptx']),
  spreadsheet(['xls', 'xlsx']);

  final List<String> extensions;

  const FileTypeGroup(this.extensions);

  static List<String> getExtensions(List<FileTypeGroup> types) {
    return types.expand((type) => type.extensions).toList();
  }
}
