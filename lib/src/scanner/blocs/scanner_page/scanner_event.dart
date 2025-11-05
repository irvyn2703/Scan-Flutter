part of 'scanner_bloc.dart';

abstract class ScannerEvent {}

class StartScanning extends ScannerEvent {}

class CodeDetected extends ScannerEvent {
  final String code;
  CodeDetected(this.code);
}

class ScannerFailed extends ScannerEvent {
  final String message;
  ScannerFailed(this.message);
}
