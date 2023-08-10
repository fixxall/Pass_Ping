import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key, required this.thrower, required this.token});
  final token;
  final Function? thrower;
  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final TextEditingController vaultnameTextEditingController = new TextEditingController();

  String passwordNow = "";
  bool isUpperCase = true;
  bool isLowerCase = true;
  bool isNumber = true;
  bool isSpecial = true;

  dynamic appSearchData;

  Future postCreateVault(vaultdata) async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultCreate), body: {
      "ApplicationId": vaultdata['ApplicationId'].toString(),
      "saved_password": vaultdata['saved_password'],
      "vault_name": vaultdata["vault_name"]
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
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          widget.thrower!(pageIndexBefore);
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

  void getAppdata() async {
    var data = await http.get(linkref.parser(linkref.main, linkref.appGetdata), headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    try {
      var jsonResult = await json.decode(data.body);
      setState(() {
        appSearchData = jsonResult['data'];
        // vaultStreamController.sink.add(vaultSearchData);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<UserModel>> searchAppmodel(filter) async {
    if (filter == '') return UserModel.fromJsonList(appSearchData);
    filter = filter.toLowerCase();
    var _data = appSearchData.where((element) {
      var a = element['name'].toString().toLowerCase();
      var b = element['app_id'].toString().toLowerCase();
      var aa = a + b;
      return aa.contains(filter);
    }).toList();
    return UserModel.fromJsonList(_data);
  }

  void generatePassword() {
    final length = 20;
    final letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    final number = '0123456789';
    final special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (isLowerCase) chars += '$letterLowerCase';
    if (isUpperCase) chars += '$letterUpperCase';
    if (isNumber) chars += '$number';
    if (isSpecial) chars += '$special';

    String hasil = List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
    setState(() {
      passwordNow = hasil;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePassword();
    getAppdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int pageIndexBefore = 1;
  int selectedIdApp = -1;

  Widget _customPopupItemBuilderExample2(BuildContext context, UserModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
        subtitle: Text(item.app_id),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  widget.thrower!(pageIndexBefore);
                },
              ),
              Text('New Record')
            ],
          ),
          Row(
            children: [
              Text('Name'),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  controller: vaultnameTextEditingController,
                  decoration: InputDecoration(
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
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle_outlined),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('App'),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: DropdownSearch<UserModel>(
                  onChanged: (val) {
                    setState(() {
                      selectedIdApp = val!.id;
                    });
                  },
                  asyncItems: (filter) => searchAppmodel(filter),
                  compareFn: (i, s) => i.isEqual(s),
                  popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    isFilterOnline: true,
                    showSelectedItems: true,
                    showSearchBox: true,
                    itemBuilder: _customPopupItemBuilderExample2,
                    favoriteItemProps: FavoriteItemProps(
                      showFavoriteItems: true,
                      favoriteItems: (us) {
                        return us.where((e) => e.name.contains("Mrs")).toList();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle_outlined),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 24),
          Text('Password'),
          SizedBox(height: 16),
          Container(
            width: scrw * 80,
            height: scrh * 5,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        Text(passwordNow),
                        Spacer(),
                        Icon(Icons.refresh_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Length'),
              SizedBox(width: 4),
              Text(passwordNow.length.toString()),
              // Slider(
              //   value: 0.9,
              //   onChanged: (newval) {
              //     print(newval);
              //   },
              // ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Numbers'),
              GFCheckbox(
                size: GFSize.SMALL,
                activeBgColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    isNumber = value;
                  });
                },
                value: isNumber,
              ),
              Text('Symbols'),
              GFCheckbox(
                size: GFSize.SMALL,
                activeBgColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    isSpecial = value;
                  });
                },
                value: isSpecial,
              ),
            ],
          ),
          Row(
            children: [
              Text('Lowercase'),
              GFCheckbox(
                size: GFSize.SMALL,
                activeBgColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    isLowerCase = value;
                  });
                },
                value: isLowerCase,
              ),
              Text('Uppercase'),
              GFCheckbox(
                size: GFSize.SMALL,
                activeBgColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    isUpperCase = value;
                  });
                },
                value: isUpperCase,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: scrw * 20,
                child: GFButton(
                  fullWidthButton: true,
                  onPressed: () {
                    generatePassword();
                  },
                  text: "Regenerate",
                  type: GFButtonType.outline,
                  shape: GFButtonShape.square,
                ),
              ),
              SizedBox(width: 16),
              Container(
                width: scrw * 20,
                child: GFButton(
                  fullWidthButton: true,
                  onPressed: () {
                    var bytes1 = utf8.encode(passwordNow); // data being hashed
                    String digest1 = "${sha256.convert(bytes1)}";
                    var vaultdata = {"ApplicationId": selectedIdApp, "saved_password": digest1, "vault_name": vaultnameTextEditingController.text};
                    postCreateVault(vaultdata);
                  },
                  text: "Save Password",
                  type: GFButtonType.outline,
                  shape: GFButtonShape.square,
                ),
              ),
            ],
          ),
          Text('Or'),
          Container(
            alignment: Alignment.center,
            width: scrw * 20,
            child: GFButton(
              fullWidthButton: true,
              onPressed: () {
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
                    onChanged: (value) => passwordNow = value,
                  ),
                  closeOnConfirmBtnTap: false,
                  onConfirmBtnTap: () async {
                    if (passwordNow.length < 8) {
                      await CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: 'Please enter at least 8 characters',
                      );

                      return;
                    }
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                );
              },
              text: "Add Manually",
              type: GFButtonType.outline,
              shape: GFButtonShape.square,
            ),
          ),
        ],
      ),
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String avatar;
  final String app_id;

  UserModel({this.id = 0, this.name = '', this.avatar = '', this.app_id = ''});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      avatar: "ava",
      app_id: json["app_id"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt.toString().contains(filter);
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
