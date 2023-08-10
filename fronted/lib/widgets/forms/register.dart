import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm(
      {super.key,
      required this.usernameregisterTextEditingController,
      required this.passwordregisterTextEditingController,
      required this.emailregisterTextEditingController,
      required this.phoneregisterTextEditingController});

  final usernameregisterTextEditingController;
  final passwordregisterTextEditingController;
  final emailregisterTextEditingController;
  final phoneregisterTextEditingController;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return Material(
      child: DefaultTextStyle(
        style: GoogleFonts.lato(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Details', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
            SizedBox(height: scrh * 2),
            TextFormField(
              controller: widget.usernameregisterTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Username',
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: widget.emailregisterTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: widget.passwordregisterTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            IntlPhoneField(
              controller: widget.phoneregisterTextEditingController,
              validator: (value) {
                if (value == null) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'ID',
              onChanged: (phone) {},
            ),
          ],
        ),
      ),
    );
  }
}
