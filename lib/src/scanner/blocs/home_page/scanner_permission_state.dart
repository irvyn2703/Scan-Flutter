part of 'scanner_permission_bloc.dart';

abstract class ScannerPermissionState {}

class PermissionInitial extends ScannerPermissionState {}

class PermissionChecking extends ScannerPermissionState {}

class PermissionGranted extends ScannerPermissionState {}

class PermissionDenied extends ScannerPermissionState {}
