import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;
  final bool isPhoneNumber;
  final bool isAfrican;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.onSaved,
    this.validator,
    this.isPhoneNumber = false,
    this.isAfrican = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String _countryCode = '+234'; // Default to Nigerian country code

  // Lists of country codes remain the same as in the original code

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    // Set initial country code based on African or Foreign phone number
    if (widget.isPhoneNumber) {
      _countryCode = widget.isAfrican ? '+234' : '+44';
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
    if (!_focusNode.hasFocus) {
      // Validate when focus is lost
      setState(() {
        _errorText = widget.validator?.call(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _errorText != null
                  ? Colors.red
                  : const Color.fromARGB(255, 137, 51, 51),
              width: _errorText != null ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Country Code Picker for Phone Numbers
              if (widget.isPhoneNumber)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                  ), // Adjust spacing
                  child: CountryCodePicker(
                    onChanged: (countryCode) {
                      setState(() {
                        _countryCode = countryCode.dialCode ?? '+234';
                      });
                    },
                    initialSelection: widget.isAfrican ? 'NG' : 'GB',
                    favorite: widget.isAfrican
                        ? ['NG', 'GH', 'KE', 'ZA']
                        : ['GB', 'FR', 'DE'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    showFlag: true,
                    enabled: true,
                  ),
                ),

              // Expanded text field
              Expanded(
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
                    prefixText: widget.isPhoneNumber
                        ? '$_countryCode'
                        : null, // Removed space here
                  ),
                  onSaved: (value) {
                    // Combine country code with phone number for phone fields
                    final processedValue = widget.isPhoneNumber
                        ? '$_countryCode${value ?? ''}' // Combines country code with input
                        : value;
                    widget.onSaved(processedValue);
                  },
                  validator: widget.validator,
                  keyboardType: widget.isPhoneNumber
                      ? TextInputType.phone
                      : TextInputType.text,
                  onChanged: (value) {
                    // Real-time validation
                    setState(() {
                      _errorText = widget.validator?.call(value);
                    });
                  },
                ),
              ),
            ],
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
  String _password = '';

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
                _password = value;
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
        if (!widget.isConfirmPassword && _password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: PasswordValidator(password: _password),
          ),
      ],
    );
  }
}

class PasswordValidator extends StatelessWidget {
  final String password;

  const PasswordValidator({super.key, required this.password});

  bool _hasThreeCharacters(String password) {
    return password.length >= 4;
  }

  bool _hasUpperCase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  bool _hasLowerCase(String password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  bool _hasSpecialCharacter(String password) {
    return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Widget _buildValidationIndicator(
      {required bool isValid, required String text}) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? Colors.green : Colors.red,
          ),
          child: Center(
            child: Icon(
              isValid ? Icons.check : Icons.close,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isValid ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildValidationIndicator(
          isValid: _hasThreeCharacters(password),
          text: 'At least 4 characters',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasUpperCase(password),
          text: '1 upper case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasLowerCase(password),
          text: '1 lower case letter',
        ),
        const SizedBox(height: 10),
        _buildValidationIndicator(
          isValid: _hasSpecialCharacter(password),
          text: '1 special character',
        ),
      ],
    );
  }
}
