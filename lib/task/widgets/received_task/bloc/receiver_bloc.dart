import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:task_repository/task_repository.dart';

part 'receiver_event.dart';
part 'receiver_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ReceiverBloc extends Bloc<ReceiverEvent, ReceiverState> {
  ReceiverBloc({required TaskRepository repository})
      : _taskRepository = repository,
        super(const ReceiverState()) {
    on<ReceiverFetchedEvent>(
      _onReceiverFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ProgressStatusChangedEvent>(_onProgressStatusChanged);
  }

  final TaskRepository _taskRepository;

  Future<void> _onReceiverFetched(
      ReceiverFetchedEvent event, Emitter<ReceiverState> emit) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: ReceiverStatus.loading));

    try {
      final tasks = await _taskRepository.fetchReceivedTasks(
          state.progressStatus.query, state.tasks.length);

      tasks.isEmpty
          ? emit(state.copyWith(
              hasReachedMax: true,
              status: ReceiverStatus.success,
            ))
          : emit(state.copyWith(
              status: ReceiverStatus.success,
              tasks: List.of(state.tasks)..addAll(tasks),
            ));
    } catch (_) {
      emit(state.copyWith(status: ReceiverStatus.failure));
    }
  }

  Future<void> _onProgressStatusChanged(
      ProgressStatusChangedEvent event, Emitter<ReceiverState> emit) async {
    emit(state.copyWith(
        progressStatus: event.status,
        status: ReceiverStatus.loading,
        tasks: List<Task>.empty()));

    try {
      final tasks =
          await _taskRepository.fetchReceivedTasks(event.status.query);
      emit(state.copyWith(
          status: ReceiverStatus.success, tasks: tasks, hasReachedMax: false));
    } catch (_) {
      emit(state.copyWith(
          status: ReceiverStatus.failure, tasks: List<Task>.empty()));
    }
  }
}

extension on TaskProgressStatus {
  String get query {
    switch (this) {
      case TaskProgressStatus.all:
        return "all";
      case TaskProgressStatus.unread:
        return "unread";
      case TaskProgressStatus.unfinished:
        return "unfinish";
    }
  }
}
