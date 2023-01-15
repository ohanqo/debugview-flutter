import 'package:debugview/mock.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mock.g.dart';

const testMock = DebugViewMock(
  label: "Test Mock",
  mockId: "test-mock",
  mockAssetPath: "test/data/test.json",
  isActiveByDefault: true,
);

@JsonSerializable()
class TestMock {
  final bool mock;

  TestMock({required this.mock});

  factory TestMock.fromJson(Map<String, dynamic> json) =>
      _$TestMockFromJson(json);
}
