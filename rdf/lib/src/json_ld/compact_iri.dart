class CompactIri {
  String prefix, suffix;

  CompactIri({this.prefix, this.suffix});

  factory CompactIri.from(Uri uri) {
    if (uri != null &&
        uri.hasScheme &&
        !uri.hasAuthority &&
        !uri.hasEmptyPath) {
      return CompactIri(prefix: uri.scheme, suffix: uri.path);
    }
    return null;
  }
}
