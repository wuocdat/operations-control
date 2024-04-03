part of 'receiver_bloc.dart';

sealed class ReceiverEvent extends Equatable {
  const ReceiverEvent();

  @override
  List<Object> get props => [];
}

final class ReceiverFetchedEvent extends ReceiverEvent {
  const ReceiverFetchedEvent();

  @override
  List<Object> get props => [];
}

final class ProgressStatusChangedEvent extends ReceiverEvent {
  const ProgressStatusChangedEvent(this.status);

  final TaskProgressStatus status;

  @override
  List<Object> get props => [];
}
