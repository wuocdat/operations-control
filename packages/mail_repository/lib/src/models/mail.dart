import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mail.g.dart';

@JsonSerializable()
final class Mail extends Equatable {
  const Mail({
    required this.content,
    required this.createdAt,
    required this.createdBy,
    required this.files,
    required this.important,
    required this.id,
    required this.name,
    required this.read,
    required this.updatedAt,
    required this.updatedBy,
  });

  final String content;
  final String createdAt;
  final Map<String, dynamic> createdBy;
  final List<String> files;
  final bool important;
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final bool read;
  final String updatedAt;
  final String updatedBy;

  static const empty = Mail(
    content: '',
    createdAt: '',
    createdBy: {},
    files: [],
    important: false,
    id: '',
    name: '',
    read: false,
    updatedAt: '',
    updatedBy: '',
  );

  factory Mail.fromJson(Map<String, dynamic> json) => _$MailFromJson(json);

  @override
  List<Object> get props => [
        content,
        createdAt,
        createdBy,
        files,
        important,
        id,
        name,
        read,
        updatedAt,
        updatedBy,
      ];
}
