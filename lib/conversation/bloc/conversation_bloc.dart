import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conversation_repository/conversation_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:tctt_mobile/services/socket_service.dart';
import 'package:tctt_mobile/shared/enums.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc(
      {required ConversationRepository conversationRepository,
      required String conversationId})
      : _conversationRepository = conversationRepository,
        _conversationId = conversationId,
        _socketIOService =
            CommunicationSocketIOService(conversationId: conversationId),
        super(const ConversationState()) {
    on<DataFetchedEvent>(_onDataFetched);
    on<MessageSentEvent>(_onMessageSent);
    on<MessageTextInputChangedEvent>(_onMessageTextInputChanged);
    on<_NewMessageReceivedEvent>(_onNewMessageReceived);

    _socketIOService.connect();

    _streamSubscription = _socketIOService.getResponse
        .listen((message) => add(_NewMessageReceivedEvent(message)));
  }

  late StreamSubscription<Message> _streamSubscription;
  final ConversationRepository _conversationRepository;
  final CommunicationSocketIOService _socketIOService;
  final String _conversationId;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _socketIOService.dispose();
    return super.close();
  }

  Future<void> _onDataFetched(
      DataFetchedEvent event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(status: FetchDataStatus.loading));

    try {
      final messages =
          await _conversationRepository.fetchMessages(_conversationId);

      emit(state.copyWith(
        status: FetchDataStatus.success,
        messages: messages.reversed.toList(),
      ));
    } catch (_) {
      emit(state.copyWith(status: FetchDataStatus.failure));
    }
  }

  void _onMessageSent(
    MessageSentEvent event,
    Emitter<ConversationState> emit,
  ) {
    _socketIOService.sendMessage(state.messageTextInput.value);
  }

  void _onMessageTextInputChanged(
      MessageTextInputChangedEvent event, Emitter<ConversationState> emit) {
    final messageTextInput = TextInput.dirty(event.text);
    emit(state.copyWith(messageText: messageTextInput));
  }

  void _onNewMessageReceived(
    _NewMessageReceivedEvent event,
    Emitter<ConversationState> emit,
  ) {
    emit(state.copyWith(
        messages: List.of(state.messages)..insert(0, event.message)));
  }
}
