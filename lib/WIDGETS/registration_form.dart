import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/WIDGETS/custom_dropdown.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationProvider>(
      builder: (context, provider, child) {
        return Form(
          key: provider.formKey,
          child: Column(
            children: [
              CustomTextField(
                label: "First Name",
                onSaved: (value) => provider.firstName = value,
                validator: (value) => provider.validateName(value),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Last Name",
                onSaved: (value) => provider.lastName = value,
                validator: (value) => provider.validateName(value),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Email",
                onSaved: (value) => provider.email = value,
                validator: (value) => provider.validateEmail(value),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "African Phone Number",
                onSaved: (value) => provider.africanPhoneNumber = value,
                validator: (value) =>
                    provider.validateAfricanPhoneNumber(value),
                isPhoneNumber: true,
                isAfrican: true,
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Foreign Phone Number",
                onSaved: (value) => provider.foreignPhoneNumber = value,
                validator: (value) =>
                    provider.validateForeignPhoneNumber(value),
                isPhoneNumber: true,
                isAfrican: false,
              ),
              const SizedBox(height: 25),
              CustomDropdown(
                label: "Gender",
                items: const ["Male", "Female"],
                onChanged: (value) => provider.gender = value,
              ),
              const SizedBox(height: 25),
              PasswordField(
                label: "Password",
                onSaved: (value) => provider.password = value,
                validator: (value) => provider.validatePassword(value),
                primaryPasswordController: provider.passwordController,
              ),
              const SizedBox(height: 20),
              PasswordField(
                label: "Confirm Password",
                onSaved: (value) => provider.confirmPassword = value,
                validator: (value) => provider.validateConfirmPassword(value),
                isConfirmPassword: true,
                primaryPasswordController: provider.passwordController,
              ),
            ],
          ),
        );
      },
    );
  }
}
