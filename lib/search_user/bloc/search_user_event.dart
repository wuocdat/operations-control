part of 'search_user_bloc.dart';

sealed class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class SearchInputChangeEvent extends SearchUserEvent {
  const SearchInputChangeEvent(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class ModeChangedEvent extends SearchUserEvent {
  const ModeChangedEvent();

  @override
  List<Object> get props => [];
}

class CheckBoxStatusChangeEvent extends SearchUserEvent {
  const CheckBoxStatusChangeEvent(this.checked, this.user);

  final bool checked;
  final ShortProfile user;

  @override
  List<Object> get props => [checked, user];
}
