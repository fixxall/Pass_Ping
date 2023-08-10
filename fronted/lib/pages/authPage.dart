import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:pass_ping_project/widgets/forms/login.dart';
import 'package:pass_ping_project/widgets/forms/register.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key, required this.thrower});
  final Function? thrower;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController usernameloginTextEditingController = new TextEditingController();
  TextEditingController passwordloginTextEditingController = new TextEditingController();
  TextEditingController usernameregisterTextEditingController = new TextEditingController();
  TextEditingController passwordregisterTextEditingController = new TextEditingController();
  TextEditingController emailregisterTextEditingController = new TextEditingController();
  TextEditingController phoneregisterTextEditingController = new TextEditingController();

  Future<dynamic> postLogin(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await http.post(linkref.parser(linkref.main, linkref.userLogin), body: {"username": email, "password": password}).timeout(Duration(seconds: 7),
        onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    if (data.statusCode != 200) {
      var jsonResult = json.decode(data.body);
      // ignore: use_build_context_synchronously
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        barrierDismissible: true,
        confirmBtnText: 'Ok',
        text: jsonResult['message'],
        closeOnConfirmBtnTap: false,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          usernameloginTextEditingController.text = "";
          passwordloginTextEditingController.text = "";
        },
      );
      return "";
    } else {
      var jsonResult = json.decode(data.body);
      var token = jsonResult['accessToken'];
      await prefs.setString("jwt", token);
      return token;
    }
  }

  Future<dynamic> postRegister(username, password, email, phone) async {
    var data = await http.post(linkref.parser(linkref.main, linkref.userRegister), body: {"username": username, "password": password}).timeout(
        Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    var jsonResult = json.decode(data.body);
    if (data.statusCode == 200) {
      // ignore: use_build_context_synchronously
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        barrierDismissible: true,
        confirmBtnText: 'Ok',
        text: jsonResult['message'],
        closeOnConfirmBtnTap: false,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          usernameregisterTextEditingController.text = "";
          passwordregisterTextEditingController.text = "";
          emailregisterTextEditingController.text = "";
          phoneregisterTextEditingController.text = "";
          setState(() {
            setIndex = 1;
          });
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        barrierDismissible: true,
        text: jsonResult['message'],
        confirmBtnText: 'Ok',
        closeOnConfirmBtnTap: false,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
        },
      );
    }
  }

  int setIndex = 1;

  @override
  void initState() {
    print("Auth page");
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Image.asset("name_logo.png", width: scrw * 80),
              Container(
                height: scrh * 50,
                width: scrw * 90,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: scrh * 5,
                        width: scrh * 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 5,
                                child: GFButton(
                                  onPressed: () {
                                    setState(() {
                                      setIndex = 0;
                                    });
                                  },
                                  text: "Register",
                                  type: GFButtonType.outline,
                                  fullWidthButton: true,
                                ),
                              ),
                              Expanded(flex: 1, child: SizedBox(width: 8)),
                              Expanded(
                                flex: 5,
                                child: GFButton(
                                    onPressed: () {
                                      setState(() {
                                        setIndex = 1;
                                      });
                                    },
                                    text: "Login",
                                    type: GFButtonType.outline,
                                    fullWidthButton: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: setIndex == 1
                          ? LoginForm(
                              emailController: usernameloginTextEditingController, passwordloginTextEditingController: passwordloginTextEditingController)
                          : RegisterForm(
                              emailregisterTextEditingController: emailregisterTextEditingController,
                              passwordregisterTextEditingController: passwordregisterTextEditingController,
                              usernameregisterTextEditingController: usernameregisterTextEditingController,
                              phoneregisterTextEditingController: phoneregisterTextEditingController),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GFButton(
              onPressed: () async {
                if (setIndex == 1) {
                  String token = await postLogin(usernameloginTextEditingController.text, passwordloginTextEditingController.text);
                  // Navigator.pushNamed(context, '/verifCode', arguments: token);
                  // if (!token) Navigator.pushNamed(context, '/home', arguments: token);
                  if (token != "") widget.thrower!(token);
                } else {
                  postRegister(usernameregisterTextEditingController.text, passwordregisterTextEditingController.text, emailregisterTextEditingController.text,
                      phoneregisterTextEditingController.text);
                }
              },
              // text: "Get Verification Code",
              text: setIndex == 1 ? "Login now" : "Register now",
              type: GFButtonType.outline),
        ),
      ],
    );
  }
}
