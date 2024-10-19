import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/auth_provider.dart';
import 'package:kakra/WIDGETS/custom_dropdown.dart';
import 'package:kakra/WIDGETS/customtext_fileds.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

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
                validator: (value) => provider.validatePhoneNumber(value),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Foreign Phone Number",
                onSaved: (value) => provider.foreignPhoneNumber = value,
                validator: (value) => provider.validatePhoneNumber(value),
              ),
              const SizedBox(height: 25),
              CustomDropdown(
                label: "Gender",
                items: const ["Male", "Female", "Other"],
                onChanged: (value) => provider.gender = value,
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Password",
                obscureText: true,
                onSaved: (value) => provider.password = value,
                validator: (value) => provider.validatePassword(value),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                label: "Confirm Password",
                obscureText: true,
                onSaved: (value) => provider.password = value,
                validator: (value) => provider.validateConfirmPassword(value),
              ),
            ],
          ),
        );
      },
    );
  }
}
