part of 'result_bloc.dart';

abstract class ResultState {
  final String result;
  const ResultState(this.result);
}

class ResultInitial extends ResultState {
  const ResultInitial(super.result);
}

class ResultIsUrl extends ResultState {
  const ResultIsUrl(super.result);
}

class ResultIsText extends ResultState {
  const ResultIsText(super.result);
}

class ResultError extends ResultState {
  final String message;
  const ResultError(super.result, this.message);
}
