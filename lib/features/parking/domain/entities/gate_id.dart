enum GateId {
  entry,
  exit;

  String get wireName => name;

  static GateId? fromWire(String value) {
    for (final id in GateId.values) {
      if (id.wireName == value.toLowerCase()) return id;
    }
    return null;
  }

  String get displayName => switch (this) {
        GateId.entry => 'Entry',
        GateId.exit => 'Exit',
      };
}
