import 'package:debugview/debugview.dart';
import 'package:debugview/response.dart';
import 'package:debugview/utils/extensions.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/mock.dart';

void main() async {
  setUpAll(nock.init);
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  /// Web server
  const baseUrl = "http://localhost/api";
  const endpoint = "/users";
  const serverHttp = "$baseUrl$endpoint";
  const result = "result";

  nock(baseUrl).get(endpoint).reply(200, result);

  /// Debugview
  final dio = Dio();

  await DebugView.instance.init(
    mockList: [testMock],
    navigatorKey: GlobalKey(),
    dioInstance: dio,
  );

  setUp(() async {
    await SharedPreferences.getInstance().then((value) => value.clear());
  });

  test("should make real call", () async {
    final mockTest = DebugView.instance.mockList.first;
    await Future(() => mockTest.isActive = false);

    final response = await dio.get(
      serverHttp,
      options: Options().mockableWith(testMock.mockId),
    );

    expect(response.data, equals(result));
  });

  test("should mock response", () async {
    final mockTest = DebugView.instance.mockList.first;
    await Future(() {
      mockTest.isActive = true;
      mockTest.throttle = 0;
      mockTest.response = DebugResponseLabel.STATUS_200.name;
    });

    final response = await dio.get(
      serverHttp,
      options: Options().mockableWith(testMock.mockId),
    );

    final data = TestMock.fromJson(response.data);
    expect(data.mock, true);
  });

  test("should mock error", () async {
    final mockTest = DebugView.instance.mockList.first;
    await Future(() {
      mockTest.isActive = true;
      mockTest.throttle = 0;
      mockTest.response = DebugResponseLabel.STATUS_403.name;
    });

    final response = await dio
        .get(
          serverHttp,
          options: Options().mockableWith(testMock.mockId),
        )
        .catchError((e) => e.response);

    expect(response.statusCode, 403);
  });

  test("should mock reponse with throttle", () async {
    final mockTest = DebugView.instance.mockList.first;
    await Future(() {
      mockTest.isActive = true;
      mockTest.throttle = 500;
      mockTest.response = DebugResponseLabel.STATUS_200.name;
    });

    final start = DateTime.now();

    final response = await dio.get(
      serverHttp,
      options: Options().mockableWith(testMock.mockId),
    );

    final end = DateTime.now();

    final timeDiff = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    expect(timeDiff, greaterThanOrEqualTo(500));

    final data = TestMock.fromJson(response.data);
    expect(data.mock, true);
  });

  test("should mock error with throttle", () async {
    final mockTest = DebugView.instance.mockList.first;
    await Future(() {
      mockTest.isActive = true;
      mockTest.throttle = 500;
      mockTest.response = DebugResponseLabel.STATUS_409.name;
    });

    final start = DateTime.now();

    final response = await dio
        .get(
          serverHttp,
          options: Options().mockableWith(testMock.mockId),
        )
        .catchError((e) => e.response);

    final end = DateTime.now();

    final timeDiff = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    expect(timeDiff, greaterThanOrEqualTo(500));

    expect(response.statusCode, 409);
  });
}
