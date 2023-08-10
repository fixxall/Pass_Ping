import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.emailController, required this.passwordloginTextEditingController});

  final emailController;
  final passwordloginTextEditingController;
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
            Text(
              'Enter Mobile No and Email',
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: scrh * 2),
            TextFormField(
              controller: widget.emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: widget.passwordloginTextEditingController,
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
            // IntlPhoneField(
            //   controller: widget.phoneController,
            //   validator: (value) {
            //     if (value == null) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Phone Number',
            //     border: OutlineInputBorder(
            //       borderSide: BorderSide(),
            //     ),
            //   ),
            //   initialCountryCode: 'ID',
            //   onChanged: (phone) {
            //     // print(phone.completeNumber);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
