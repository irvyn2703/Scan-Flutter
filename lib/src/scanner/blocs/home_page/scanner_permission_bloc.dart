import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'scanner_permission_event.dart';
part 'scanner_permission_state.dart';

class ScannerPermissionBloc
    extends Bloc<ScannerPermissionEvent, ScannerPermissionState> {
  ScannerPermissionBloc() : super(PermissionInitial()) {
    on<CheckPermission>(_onCheckPermission);
    on<RequestPermission>(_onRequestPermission);
  }

  Future<void> _onCheckPermission(
    CheckPermission event,
    Emitter<ScannerPermissionState> emit,
  ) async {
    emit(PermissionChecking());
    final status = await Permission.camera.status;
    if (status.isGranted) {
      emit(PermissionGranted());
    } else {
      emit(PermissionDenied());
    }
  }

  Future<void> _onRequestPermission(
    RequestPermission event,
    Emitter<ScannerPermissionState> emit,
  ) async {
    emit(PermissionChecking());
    final newStatus = await Permission.camera.request();
    if (newStatus.isGranted) {
      emit(PermissionGranted());
    } else {
      emit(PermissionDenied());
    }
  }
}
