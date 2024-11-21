import 'package:flutter/material.dart';
import 'package:kakra/WIDGETS/password_validator.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.onSaved,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Validate when focus is lost
      setState(() {
        _errorText = widget.validator?.call(_controller.text);
      });
    }
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _errorText != null ? Colors.red : Colors.grey,
              width: _errorText != null ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _errorText != null ? Colors.red : Colors.black,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              fillColor: Colors.white,
            ),
            onSaved: widget.onSaved,
            validator: widget.validator,
            onChanged: (value) {
              // Real-time validation
              setState(() {
                _errorText = widget.validator?.call(value);
              });
            },
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final String label;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;
  final bool isConfirmPassword;
  final TextEditingController? primaryPasswordController;

  const PasswordField({
    super.key,
    required this.label,
    required this.onSaved,
    this.validator,
    this.isConfirmPassword = false,
    this.primaryPasswordController,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final TextEditingController _controller = TextEditingController();
  bool _showPassword = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _errorText != null ? Colors.red : Colors.grey,
              width: _errorText != null ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: widget.isConfirmPassword
                ? _controller
                : widget.primaryPasswordController ?? _controller,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: _errorText != null ? Colors.red : Colors.black,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
            ),
            onSaved: widget.onSaved,
            validator: (value) {
              if (widget.isConfirmPassword) {
                if (widget.primaryPasswordController?.text != value) {
                  return "Passwords do not match";
                }
              }
              return widget.validator?.call(value);
            },
            onChanged: (value) {
              setState(() {
                _errorText = widget.validator?.call(value);
              });
            },
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
