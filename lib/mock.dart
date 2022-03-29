import 'package:debugview/response.dart';
import 'package:debugview/utils/prefs.dart';

class Mock {
  final String label;
  final String mockId;
  final String mockAssetPath;

  Mock.init(this.label, this.mockId, this.mockAssetPath);

  factory Mock.factory({
    required String label,
    required String mockId,
    required String mockAssetPath,
    bool isActiveByDefault = false,
  }) {
    final mock = Mock.init(
      label,
      mockId,
      mockAssetPath,
    );
    mock.isActive ??= isActiveByDefault;
    return mock;
  }

  bool? get isActive {
    return Prefs().getBool(mockId);
  }

  set isActive(bool? _isActive) {
    if (_isActive != null) {
      Prefs().setBool(id: mockId, value: _isActive);
    }
  }

  int get throttle {
    return Prefs().getInt("$mockId-throttle");
  }

  set throttle(int value) {
    Prefs().setInt(id: "$mockId-throttle", value: value);
  }

  String get response {
    return Prefs().getString("$mockId-response") ??
        DebugResponseLabel.STATUS_200.name;
  }

  set response(String value) {
    Prefs().setString(id: "$mockId-response", value: value);
  }
}

class DebugViewMock {
  const DebugViewMock({
    required this.label,
    required this.mockId,
    required this.mockAssetPath,
    this.isActiveByDefault = false,
  });

  final String label;
  final String mockId;
  final String mockAssetPath;
  final bool isActiveByDefault;

  Mock toMock() {
    return Mock.factory(
      label: label,
      mockId: mockId,
      mockAssetPath: mockAssetPath,
      isActiveByDefault: isActiveByDefault,
    );
  }
}
