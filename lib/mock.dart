import 'package:debugview/utils/prefs.dart';

class Mock {
  const Mock({
    required this.label,
    required this.mockAssetPath,
  });

  final String label;
  final String mockAssetPath;

  bool get isActive {
    return Prefs().getBool(label);
  }

  set isActive(bool _isActive) {
    Prefs().setBool(label: label, value: _isActive);
  }
}
