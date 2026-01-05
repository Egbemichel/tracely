class TrailMatcher {
  static String normalize(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '');

  static bool sameTopic(String a, String b) {
    final wa = normalize(a).split(' ');
    final wb = normalize(b).split(' ');
    return wa.any(wb.contains);
  }
}
