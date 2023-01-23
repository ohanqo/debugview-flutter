import 'package:debugview/debugview.dart';
import 'package:debugview/mock.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/mock.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUp(() async {
    await SharedPreferences.getInstance().then((value) => value.clear());
  });

  test("should be active by defaults if defined", () async {
    const testEnabled1Mock = DebugViewMock(
      label: "Test Enabled1 Mock",
      mockId: "test-enabled1-mock",
      mockAssetPath: "test/data/test.json",
      isActiveByDefault: true,
    );

    const testEnabled2Mock = DebugViewMock(
      label: "Test Enabled2 Mock",
      mockId: "test-enabled2-mock",
      mockAssetPath: "test/data/test.json",
      isActiveByDefault: true,
    );

    const testEnabled3Mock = DebugViewMock(
      label: "Test Enabled3 Mock",
      mockId: "test-enabled3-mock",
      mockAssetPath: "test/data/test.json",
      isActiveByDefault: false,
    );

    await DebugView.instance.init(
      mockList: [testEnabled1Mock, testEnabled2Mock, testEnabled3Mock],
      navigatorKey: GlobalKey(),
      dioInstance: Dio(),
    );

    expect(DebugView.instance.mockList.first.isActive, true);
    expect(DebugView.instance.mockList.elementAt(1).isActive, true);
    expect(DebugView.instance.mockList.last.isActive, false);
  });

  test("should enable all mocks", () async {
    await DebugView.instance.init(
      mockList: [testMock, test2Mock],
      navigatorKey: GlobalKey(),
      dioInstance: Dio(),
    );

    DebugView.instance.enableMocks();

    expect(DebugView.instance.mockList.first.isActive, true);
    expect(DebugView.instance.mockList.last.isActive, true);
  });

  test("should enable specific mocks", () async {
    await DebugView.instance.init(
      mockList: [testMock, test2Mock],
      navigatorKey: GlobalKey(),
      dioInstance: Dio(),
    );

    DebugView.instance.enableMocks([testMock.mockId]);

    expect(DebugView.instance.mockList.first.isActive, true);
    expect(DebugView.instance.mockList.last.isActive, true);
  });

  test("should disable all mocks", () async {
    await DebugView.instance.init(
      mockList: [testMock, test2Mock],
      navigatorKey: GlobalKey(),
      dioInstance: Dio(),
    );

    DebugView.instance.disableMocks();

    expect(DebugView.instance.mockList.first.isActive, false);
    expect(DebugView.instance.mockList.last.isActive, false);
  });

  test("should disable specific mocks", () async {
    await DebugView.instance.init(
      mockList: [testMock, test2Mock],
      navigatorKey: GlobalKey(),
      dioInstance: Dio(),
    );

    DebugView.instance.disableMocks([testMock.mockId]);

    expect(DebugView.instance.mockList.first.isActive, false);
    expect(DebugView.instance.mockList.last.isActive, true);
  });
}
