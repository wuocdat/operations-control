import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/task_repository.dart';
import 'package:tctt_mobile/shared/debounce.dart';

part 'receiver_event.dart';
part 'receiver_state.dart';

class ReceiverBloc extends Bloc<ReceiverEvent, ReceiverState> {
  ReceiverBloc({required TaskRepository repository})
      : _taskRepository = repository,
        super(const ReceiverState()) {
    on<ReceiverFetchedEvent>(
      _onReceiverFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ProgressStatusChangedEvent>(_onProgressStatusChanged);
    on<SearchInputChangedEvent>(_onSearchInputChanged,
        transformer: debounce(debounceDuration));
    on<ReceiverResetEvent>(_onReload);
  }

  final TaskRepository _taskRepository;

  Future<void> _onReceiverFetched(
      ReceiverFetchedEvent event, Emitter<ReceiverState> emit) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: ReceiverStatus.loading));

    try {
      final tasks = await _taskRepository.fetchReceivedTasks(
        state.progressStatus.query,
        state.searchValue,
        state.tasks.length,
      );

      tasks.length < taskLimit
          ? emit(state.copyWith(
              hasReachedMax: true,
              status: ReceiverStatus.success,
              tasks: List.of(state.tasks)..addAll(tasks),
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
      tasks: List<Task>.empty(),
    ));

    try {
      final tasks = await _taskRepository.fetchReceivedTasks(
          event.status.query, state.searchValue);
      emit(state.copyWith(
          status: ReceiverStatus.success,
          tasks: tasks,
          hasReachedMax: tasks.length < taskLimit));
    } catch (_) {
      emit(state.copyWith(
          status: ReceiverStatus.failure, tasks: List<Task>.empty()));
    }
  }

  Future<void> _onSearchInputChanged(
      SearchInputChangedEvent event, Emitter<ReceiverState> emit) async {
    emit(state.copyWith(
        searchValue: event.searchValue,
        status: ReceiverStatus.loading,
        tasks: List<Task>.empty()));

    try {
      final tasks = await _taskRepository.fetchReceivedTasks(
          state.progressStatus.query, event.searchValue);
      emit(state.copyWith(
          status: ReceiverStatus.success,
          tasks: tasks,
          hasReachedMax: tasks.length < taskLimit));
    } catch (_) {
      emit(state.copyWith(
        status: ReceiverStatus.failure,
        tasks: List<Task>.empty(),
      ));
    }
  }

  Future<void> _onReload(
    ReceiverResetEvent event,
    Emitter<ReceiverState> emit,
  ) async {
    emit(state.copyWith(
        status: ReceiverStatus.loading, tasks: List<Task>.empty()));

    try {
      final tasks = await _taskRepository.fetchReceivedTasks(
          state.progressStatus.query, state.searchValue);
      emit(state.copyWith(
        status: ReceiverStatus.success,
        tasks: tasks,
        hasReachedMax: tasks.length < taskLimit,
      ));
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
