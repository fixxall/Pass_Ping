import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:pass_ping_project/widgets/passwords/passwordList.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class PasswordPage extends StatefulWidget {
  PasswordPage({super.key, required this.thrower, required this.token, required this.detailPage});
  final token;

  final Function? thrower;
  final Function? detailPage;
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  StreamController vaultStreamController = new StreamController.broadcast();
  dynamic vaultSearchData;

  Future<dynamic> getVaultData() async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultGetdata), body: {
      "option": "category"
    }, headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    try {
      var jsonResult = json.decode(data.body);
      setState(() {
        vaultSearchData = jsonResult['data'];
        print(vaultSearchData.length);
        vaultStreamController.sink.add(vaultSearchData);
      });
    } catch (e) {
      print(e);
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  widget.thrower!(6);
                },
              ),
              Text('Password'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.search_rounded),
                onPressed: () {
                  widget.thrower!(4);
                },
              ),
            ],
          ),
          SizedBox(height: scrh * 3),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: vaultStreamController.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();
                      else if (snapshot.hasData) {
                        var datas = snapshot.data;
                        return ListView.builder(
                          itemCount: datas.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            dynamic contain = datas[index];
                            return CategApp(contain: contain, scrw: scrw, scrh: scrh, detailPage: widget.detailPage);
                          },
                        );
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategApp extends StatelessWidget {
  const CategApp({
    super.key,
    required this.contain,
    required this.scrw,
    required this.scrh,
    required this.detailPage,
  });

  final dynamic contain;
  final double scrw;
  final double scrh;
  final Function? detailPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(contain['category']),
        ListView.builder(
          itemCount: contain['data'].length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var data = contain['data'][index];
            return PasswordListWidget(scrw: scrw, scrh: scrh, data: data, detailPage: detailPage);
          },
        ),
      ],
    );
  }
}
