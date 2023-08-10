import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class DetailPassword extends StatefulWidget {
  const DetailPassword({super.key, required this.thrower, required this.token, required this.detailPageId, required this.pageIndexBefore});
  final detailPageId;
  final token;
  final pageIndexBefore;
  final Function? thrower;

  @override
  State<DetailPassword> createState() => _DetailPasswordState();
}

class _DetailPasswordState extends State<DetailPassword> {
  final int leftSide = 5;
  final int rightSide = 8;
  StreamController dataController = new StreamController.broadcast();

  Future<dynamic> getVaultData() async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultGetFromId), body: {
      "VaultId": widget.detailPageId.toString()
    }, headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    try {
      var jsonResult = json.decode(data.body);
      setState(() {
        dataController.sink.add(jsonResult['data']);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postDestroy(int idVaul) async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultDestroy), body: {
      "VaultId": idVaul.toString()
    }, headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
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
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          widget.thrower!(widget.pageIndexBefore);
        },
      );
    } else {
      var jsonResult = json.decode(data.body);
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

  Future<dynamic> postEdit(int vaulid, String savePass) async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultEdit), body: {
      "saved_password": savePass,
      "VaultId": vaulid.toString(),
    }, headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
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
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      var jsonResult = json.decode(data.body);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVaultData();
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
    return StreamBuilder(
        stream: dataController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            var data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultTextStyle(
                style: GoogleFonts.lato(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            widget.thrower!(widget.pageIndexBefore);
                          },
                        ),
                        Text('Back', style: GoogleFonts.lato()),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete_forever_rounded),
                          onPressed: () {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Do you want to delete this vault',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                onConfirmBtnTap: () {
                                  postDestroy(data['id']);
                                },
                                confirmBtnColor: Colors.green,
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: scrh * 3),
                    Row(
                      children: [
                        GFAvatar(
                          backgroundImage: NetworkImage(data['Application']['imageurl']),
                        ),
                        SizedBox(width: scrw * 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['vault_name'], style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            SizedBox(height: scrh),
                            Text(data['Application']['name']),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: scrh * 3),
                    Text('Details & Settings', style: GoogleFonts.lato(letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 16)),
                    Divider(),
                    Row(
                      children: [
                        Expanded(flex: leftSide, child: Text('Link', style: GoogleFonts.lato(letterSpacing: 1, fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: rightSide,
                          child: Text('https://www.' + data['Application']['app_id']),
                        ),
                      ],
                    ),
                    SizedBox(height: scrh),
                    Row(
                      children: [
                        Expanded(flex: leftSide, child: Text('appid', style: GoogleFonts.lato(letterSpacing: 1, fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: rightSide,
                          child: Text(data['Application']['app_id']),
                        ),
                      ],
                    ),
                    SizedBox(height: scrh),
                    Row(
                      children: [
                        Expanded(flex: leftSide, child: Text('Password', style: GoogleFonts.lato(letterSpacing: 1, fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: rightSide,
                          child: Text(data['saved_password']),
                        ),
                      ],
                    ),
                    SizedBox(height: scrh),
                    Row(
                      children: [
                        Expanded(flex: leftSide, child: Text("Encrypt", style: GoogleFonts.lato(letterSpacing: 1, fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: rightSide,
                          child: GFToggle(
                            onChanged: (val) {},
                            value: true,
                            type: GFToggleType.ios,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: scrh),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: scrw * 20,
                          child: GFButton(
                            fullWidthButton: true,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: data['saved_password'])).then((value) => //only if ->
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('password have been copied to clipboard'))));
                            },
                            text: "Copy Password",
                            type: GFButtonType.outline,
                            shape: GFButtonShape.square,
                          ),
                        ),
                        SizedBox(width: scrw * 5),
                        Container(
                          width: scrw * 20,
                          child: GFButton(
                            fullWidthButton: true,
                            onPressed: () {
                              String resetSavePass = "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.custom,
                                barrierDismissible: true,
                                confirmBtnText: 'Save',
                                widget: TextFormField(
                                  controller: TextEditingController(),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Password',
                                    prefixIcon: Icon(
                                      Icons.key,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) => resetSavePass = value,
                                ),
                                closeOnConfirmBtnTap: false,
                                onConfirmBtnTap: () async {
                                  if (resetSavePass.length < 8) {
                                    await CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: 'Please enter at least 8 characters',
                                    );

                                    return;
                                  } else {
                                    var bytes1 = utf8.encode(resetSavePass); // data being hashed
                                    String digest1 = "${sha256.convert(bytes1)}";
                                    postEdit(data['id'], digest1);
                                  }
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            text: "Reset Password",
                            type: GFButtonType.outline,
                            shape: GFButtonShape.square,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
