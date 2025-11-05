part of 'scanner_permission_bloc.dart';

abstract class ScannerPermissionEvent {}

class CheckPermission extends ScannerPermissionEvent {}

class RequestPermission extends ScannerPermissionEvent {}
