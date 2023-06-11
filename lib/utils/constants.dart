import 'package:debugview/response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const mainColor = Color(0xff2292EB);

const responses = [
  DebugResponse(
    label: DebugResponseLabel.STATUS_200,
    isError: false,
    status: 200,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_201,
    isError: false,
    status: 201,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_204,
    isError: false,
    status: 204,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_304,
    isError: false,
    status: 304,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_400,
    isError: true,
    status: 400,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_401,
    isError: true,
    status: 401,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_403,
    isError: true,
    status: 403,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_404,
    isError: true,
    status: 404,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_409,
    isError: true,
    status: 409,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_410,
    isError: true,
    status: 410,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.STATUS_500,
    isError: true,
    status: 500,
    dioErrorType: DioExceptionType.badResponse,
  ),
  DebugResponse(
    label: DebugResponseLabel.EXCEPTION_CONNECT_TIMEOUT,
    isError: true,
    dioErrorType: DioExceptionType.connectionTimeout,
  ),
  DebugResponse(
    label: DebugResponseLabel.EXCEPTION_SEND_TIMEOUT,
    isError: true,
    dioErrorType: DioExceptionType.sendTimeout,
  ),
  DebugResponse(
    label: DebugResponseLabel.EXCEPTION_RECEIVE_TIMEOUT,
    isError: true,
    dioErrorType: DioExceptionType.receiveTimeout,
  ),
  DebugResponse(
    label: DebugResponseLabel.EXCEPTION_CANCEL,
    isError: true,
    dioErrorType: DioExceptionType.cancel,
  ),
  DebugResponse(
    label: DebugResponseLabel.EXCEPTION_OTHER,
    isError: true,
    dioErrorType: DioExceptionType.unknown,
  ),
];
