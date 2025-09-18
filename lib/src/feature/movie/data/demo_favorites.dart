class DemoFavorites {
  static final Set<String> _ids = <String>{};

  static bool isFavorite(String id) => _ids.contains(id);

  static void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
  }

  static void setFavorite(String id, bool value) {
    if (value) {
      _ids.add(id);
    } else {
      _ids.remove(id);
    }
  }

  static List<String> all() => _ids.toList(growable: false);
}


