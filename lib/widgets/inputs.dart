import 'package:flutter/material.dart';
import 'package:tctt_mobile/theme/colors.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.labelText,
    this.errorText,
    this.onChanged,
    this.isPassword = false,
  });

  final String labelText;
  final String? errorText;
  final bool isPassword;
  final void Function(String)? onChanged;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      obscureText: passwordVisibility,
      decoration: InputDecoration(
        labelText: widget.labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFF1F4F8),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppColors.secondaryBackground,
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () => setState(
                  () => passwordVisibility = !passwordVisibility,
                ),
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  passwordVisibility
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  // color: theme.secondaryText,
                  size: 24,
                ),
              )
            : null,
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    this.onChanged,
  });

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      autofocus: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFF1F4F8),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      ),
    );
  }
}

class BorderInput extends StatelessWidget {
  const BorderInput({
    super.key,
    bool? autoFocus,
    required String labelText,
    int? maxLines,
    int? minLines,
    int? maxLength,
    String? errorText,
    ValueChanged<String>? onChanged,
  })  : _autoFocus = autoFocus,
        _labelText = labelText,
        _maxLines = maxLines,
        _minLines = minLines,
        _maxLength = maxLength,
        _errorText = errorText,
        _onChanged = onChanged;

  final bool? _autoFocus;
  final String _labelText;
  final String? _errorText;
  final int? _maxLines;
  final int? _minLines;
  final int? _maxLength;
  final ValueChanged<String>? _onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      autofocus: _autoFocus ?? false,
      obscureText: false,
      onChanged: _onChanged,
      decoration: InputDecoration(
        labelText: _labelText,
        errorText: _errorText,
        alignLabelWithHint: true,
        hintStyle: theme.textTheme.labelLarge?.copyWith(
          fontFamily: 'Plus Jakarta Sans',
          letterSpacing: 0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.secondaryBackground,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        fontFamily: 'Plus Jakarta Sans',
        letterSpacing: 0,
      ),
      minLines: _minLines,
      maxLines: _maxLines,
      maxLength: _maxLength,
      cursorColor: theme.primaryColor,
    );
  }
}