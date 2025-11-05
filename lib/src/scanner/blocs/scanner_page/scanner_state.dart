part of 'scanner_bloc.dart';

abstract class ScannerState {}

class ScannerInitial extends ScannerState {}

class ScannerScanning extends ScannerState {}

class ScannerDetected extends ScannerState {
  final String code;
  ScannerDetected(this.code);
}

class ScannerError extends ScannerState {
  final String message;
  ScannerError(this.message);
}
