import 'package:flutter_bloc/flutter_bloc.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerInitial()) {
    on<StartScanning>((event, emit) => emit(ScannerScanning()));

    on<CodeDetected>((event, emit) {
      emit(ScannerDetected(event.code));
    });

    on<ScannerFailed>((event, emit) {
      emit(ScannerError(event.message));
    });
  }
}
