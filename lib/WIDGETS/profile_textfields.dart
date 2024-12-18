import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:kakra/PROVIDERS/profile_update_provider.dart';

class ProfileTextField extends StatefulWidget {
  final String label;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isRequired;
  final int? maxLength;
  final Widget? prefixIcon;
  final String? helperText;
  final bool enableSuggestions;
  final String providerKey; // New parameter to specify the key in the provider

  final Iterable<String>? autofillHints; // Optional autofillHints
  final TextInputAction? textInputAction; // Optional textInputAction

  const ProfileTextField({
    Key? key,
    required this.label,
    required this.providerKey, // Make this required
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.isRequired = false,
    this.maxLength,
    this.prefixIcon,
    this.helperText,
    this.enableSuggestions = true,
    this.autofillHints, // Optional
    this.textInputAction, // Optional
  }) : super(key: key);

  @override
  _ProfileTextFieldState createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    // Retrieve initial value from provider if exists
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final initialValue = provider.formData[widget.providerKey];
    if (initialValue != null) {
      _controller.text = initialValue;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (!_focusNode.hasFocus) {
        _validateField(_controller.text);
      }
    });
  }

  void _validateField(String? value) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);

    // Determine validation method based on the field
    String? errorMessage;
    switch (widget.label.toLowerCase()) {
      case 'first name':
      case 'last name':
        errorMessage =
            provider.validateName(value, isRequired: widget.isRequired);
        break;
      case 'email address':
        errorMessage = provider.validateEmail(value);
        break;
      case 'african phone number':
      case 'foreign phone number':
        errorMessage = provider.validatePhoneNumber(value);
        break;
      case 'current location':
      case 'state/region you reside':
      case 'country':
        errorMessage = provider.validateLocation(value);
        break;
      case 'skills':
      case 'interests':
        errorMessage = provider.validateSkillsOrInterests(value);
        break;
      default:
        // For other fields, use custom validator if provided
        errorMessage = widget.validator?.call(value);
    }
    // More robust error handling
    try {
      switch (widget.label.toLowerCase()) {
        // Your existing switch cases
      }
    } catch (e) {
      errorMessage = 'Validation error occurred';
      // Optionally log the error
    }
    setState(() {
      _errorText = errorMessage;
    });

    // Update form data in provider
    if (errorMessage == null) {
      provider.updateFormData(widget.providerKey, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            border: Border.all(
              color: _errorText != null
                  ? Colors.red
                  : _isFocused
                      ? Colors.blue
                      : Colors.grey[400]!,
              width: _errorText != null ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextFormField(
            textInputAction: widget.textInputAction, // TextInputAction
            autofillHints: widget.autofillHints, // AutofillHints

            controller: _controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            enableSuggestions: widget.enableSuggestions,
            decoration: InputDecoration(
              labelText: widget.isRequired ? '${widget.label} *' : widget.label,
              labelStyle: TextStyle(
                color: _errorText != null
                    ? Colors.red
                    : _isFocused
                        ? Colors.blue
                        : Colors.grey[600],
              ),
              prefixIcon: widget.prefixIcon,
              helperText: widget.helperText,
              helperStyle: TextStyle(color: Colors.grey[600]),
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onSaved: (value) {
              provider.updateFormData(widget.providerKey, value);
            },
            onChanged: _validateField,
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
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

// Helper method
List<String> _getAutofillHints(String label) {
  switch (label.toLowerCase()) {
    case 'first name':
      return [AutofillHints.givenName];
    case 'last name':
      return [AutofillHints.familyName];
    case 'email address':
      return [AutofillHints.email];
    case 'phone number':
      return [AutofillHints.telephoneNumber];
    default:
      return [];
  }
}
