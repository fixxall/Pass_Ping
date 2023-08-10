import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pass_ping_project/widgets/passwords/passwordList.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class SearchPasswordPage extends StatefulWidget {
  SearchPasswordPage({super.key, required this.thrower, required this.token, required this.detailPage});
  final token;

  final Function? thrower;
  final Function? detailPage;

  @override
  State<SearchPasswordPage> createState() => _SearchPasswordPageState();
}

class _SearchPasswordPageState extends State<SearchPasswordPage> {
  StreamController vaultStreamController = new StreamController.broadcast();
  dynamic vaultSearchData;

  Future<dynamic> getVaultData() async {
    var data = await http.post(linkref.parser(linkref.main, linkref.vaultGetdata), headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    try {
      var jsonResult = json.decode(data.body);
      setState(() {
        vaultSearchData = jsonResult['data'];
        vaultStreamController.sink.add(vaultSearchData);
      });
    } catch (e) {
      print(e);
    }
  }

  searchPass(text) {
    text = text.toLowerCase();
    var _data = vaultSearchData.where((element) {
      var a = element['Application']['name'].toString().toLowerCase();
      var aa = a;
      return aa.contains(text);
    }).toList();
    vaultStreamController.sink.add(_data);
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
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  widget.thrower!(1);
                },
              ),
              Expanded(
                child: TextFormField(
                  onChanged: searchPass,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 11.0),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Search password',
                      hintStyle: TextStyle(fontSize: 11.0)),
                ),
              ),
            ],
          ),
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
                        if (datas.length == 0)
                          return Text('No have data');
                        else
                          return ListView.builder(
                            itemCount: datas.length > 10 ? 10 : datas.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var data = datas[index];
                              return PasswordListWidget(scrw: scrw, scrh: scrh, data: data, detailPage: widget.detailPage);
                            },
                          );
                      } else
                        return CircularProgressIndicator();
                    }),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
