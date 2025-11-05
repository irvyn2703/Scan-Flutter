import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  ResultBloc(String initialResult) : super(ResultInitial(initialResult)) {
    on<CheckResultType>(_onCheckResultType);
    on<LaunchUrl>(_onLaunchUrl);
    on<CopyText>(_onCopyText);
  }

  Future<void> _onCheckResultType(
    CheckResultType event,
    Emitter<ResultState> emit,
  ) async {
    final uri = Uri.tryParse(event.result);
    if (uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https')) {
      emit(ResultIsUrl(event.result));
    } else {
      emit(ResultIsText(event.result));
    }
  }

  Future<void> _onLaunchUrl(LaunchUrl event, Emitter<ResultState> emit) async {
    try {
      await EasyLauncher.url(url: state.result);
    } catch (e) {
      emit(ResultError(state.result, 'No se pudo abrir el enlace.'));
    }
  }

  Future<void> _onCopyText(CopyText event, Emitter<ResultState> emit) async {
    await Clipboard.setData(ClipboardData(text: state.result));
  }
}
