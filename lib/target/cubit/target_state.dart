part of 'target_cubit.dart';

enum TargetOptions { subject, chanel }

enum FbPageType { fanpage, personalPage, openGroup }

extension FbPageTypeX on FbPageType {
  String get title {
    switch (this) {
      case FbPageType.fanpage:
        return 'Fanpage';
      case FbPageType.openGroup:
        return 'Nhóm mở';
      case FbPageType.personalPage:
        return 'Trang cá nhân';
    }
  }
}

extension TargetOptionsX on TargetOptions {
  String get title {
    if (this == TargetOptions.subject) {
      return "Đối tượng";
    } else {
      return "Kênh truyền thông";
    }
  }

  bool get isSubject => this == TargetOptions.subject;
}

class TargetState extends Equatable {
  const TargetState._({
    this.selectedOption = TargetOptions.subject,
  });

  const TargetState.subject() : this._();

  const TargetState.chanel() : this._(selectedOption: TargetOptions.chanel);

  final TargetOptions selectedOption;

  TargetState copyWith({
    TargetOptions? selectedOption,
  }) {
    return TargetState._(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  @override
  List<Object> get props => [selectedOption];
}