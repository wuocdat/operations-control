import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tree/flutter_tree.dart';
import 'package:formz/formz.dart';
import 'package:tctt_mobile/new_task/models/models.dart';
import 'package:tctt_mobile/shared/enums.dart';
import 'package:units_repository/units_repository.dart';

part 'new_task_event.dart';
part 'new_task_state.dart';

class NewTaskBloc extends Bloc<NewTaskEvent, NewTaskState> {
  NewTaskBloc({
    required UnitsRepository unitsRepository,
  })  : _unitsRepository = unitsRepository,
        super(const NewTaskState()) {
    on<TitleChanged>(_onTitleChanged);
    on<ContentChanged>(_onContentChanged);
    on<UnitsChanged>(_onUnitsChanged);
    on<TypeChanged>(_onTaskTypeChanged);
    on<ImportantToggled>(_onImportantToggled);
    on<NewTaskSubmitted>(_onNewTaskSubmitted);
    on<NewTaskStarted>(_onNewTaskStarted);
    on<FilePicked>(_onFilesPicked);
  }

  final UnitsRepository _unitsRepository;

  Future<void> _onNewTaskStarted(
      NewTaskStarted event, Emitter<NewTaskState> emit) async {
    emit(state.copyWith(fetchDataStatus: FetchDataStatus.loading));
    try {
      final units = await _unitsRepository.getUnitsByParentId(event.unitId);

      emit(state.copyWith(
        fetchDataStatus: FetchDataStatus.success,
        childrenUnits: units,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(fetchDataStatus: FetchDataStatus.failure));
    }
  }

  void _onTitleChanged(TitleChanged event, Emitter<NewTaskState> emit) {
    final title = Title.dirty(event.title);
    emit(state.copyWith(
      title: title,
      isValid: Formz.validate([title, state.content]) &&
          state.units.isNotEmpty &&
          state.files.isNotEmpty,
    ));
  }

  void _onContentChanged(ContentChanged event, Emitter<NewTaskState> emit) {
    final content = Content.dirty(event.content);
    emit(state.copyWith(
      content: content,
      isValid: Formz.validate([state.title, content]) &&
          state.units.isNotEmpty &&
          state.files.isNotEmpty,
    ));
  }

  void _onTaskTypeChanged(TypeChanged event, Emitter<NewTaskState> emit) {
    emit(state.copyWith(type: event.type));
  }

  void _onUnitsChanged(UnitsChanged event, Emitter<NewTaskState> emit) {
    final cloneUnits = List.of(state.units);

    if (event.checked) {
      cloneUnits.add(event.unit);
    } else {
      cloneUnits.remove(event.unit);
    }

    emit(state.copyWith(
      units: cloneUnits,
      isValid: Formz.validate([state.content, state.title]) &&
          cloneUnits.isNotEmpty &&
          state.files.isNotEmpty,
    ));
  }

  void _onImportantToggled(ImportantToggled event, Emitter<NewTaskState> emit) {
    emit(state.copyWith(important: !state.important));
  }

  void _onNewTaskSubmitted(NewTaskSubmitted event, Emitter<NewTaskState> emit) {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    }
  }

  void _onFilesPicked(FilePicked event, Emitter<NewTaskState> emit) {
    emit(state.copyWith(
      files: event.files,
      isValid: Formz.validate([state.content, state.title]) &&
          state.units.isNotEmpty &&
          event.files.isNotEmpty,
    ));
  }

  Future<List<TreeNodeData>> loadTreeNode(String parent) async {
    try {
      final units = await _unitsRepository.getUnitsByParentId(parent);
      debugPrint(units.toString());

      return units.map((e) => e.toTreeNodeData()).toList();
    } catch (_) {
      return [];
    }
  }
}

extension UnitX on Unit {
  TreeNodeData toTreeNodeData() {
    return TreeNodeData(
      extra: id,
      title: name,
      expaned: false,
      checked: false,
      children: [],
    );
  }
}