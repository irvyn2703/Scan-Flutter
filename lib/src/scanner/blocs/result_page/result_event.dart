part of 'result_bloc.dart';

abstract class ResultEvent {}

class CheckResultType extends ResultEvent {
  final String result;
  CheckResultType(this.result);
}

class LaunchUrl extends ResultEvent {}

class CopyText extends ResultEvent {}
