import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_ping_project/settings/colorlib.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key, required this.thrower, required this.token, required this.detailPage});

  final Function? thrower;
  final Function? detailPage;
  final token;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  StreamController vaultStreamController = StreamController.broadcast();
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
          Text(
            'SECURITY',
            style: GoogleFonts.lato(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 24, color: colorlib.primer),
          ),
          SizedBox(
            height: scrh * 5,
          ),
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 10.0,
            percent: 0.9,
            center: DefaultTextStyle(
              style: GoogleFonts.raleway(fontSize: 16, letterSpacing: 1.5, color: colorlib.primer),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("90%"),
                  Text("Vault"),
                ],
              ),
            ),
            progressColor: colorlib.secunder,
          ),
          SizedBox(
            height: scrh * 3,
          ),
          Text(
            'You Have 100 Password Saved',
            style: GoogleFonts.raleway(fontSize: 16, letterSpacing: 1.5, color: colorlib.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '90% Of Them Are Secured',
                style: GoogleFonts.raleway(fontSize: 16, letterSpacing: 1.5, color: colorlib.black),
              ),
              const SizedBox(width: 5),
              Icon(Icons.check_circle_rounded, color: colorlib.secunder)
            ],
          ),
          SizedBox(
            height: scrh * 3,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: InfoBox(
                  borderColor: GFColors.SUCCESS,
                  backColor: Colors.transparent,
                  scrw: scrw,
                  scrh: scrh,
                  name: 'SAFE',
                  count: 82,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 5,
                child: InfoBox(
                  borderColor: GFColors.WARNING,
                  backColor: Colors.transparent,
                  scrw: scrw,
                  scrh: scrh,
                  name: 'WARNING',
                  count: 21,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 5,
                child: InfoBox(
                  borderColor: GFColors.DANGER,
                  backColor: Colors.transparent,
                  scrw: scrw,
                  scrh: scrh,
                  name: 'ALERT',
                  count: 82,
                ),
              ),
            ],
          ),
          SizedBox(
            height: scrh * 5,
          ),
          Row(
            children: [
              Text(
                'ANALYSIS',
                style: GoogleFonts.raleway(fontSize: 16, letterSpacing: 3, color: colorlib.black, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.sort_rounded, color: colorlib.black)
            ],
          ),
          SizedBox(
            height: scrh,
          ),
          Expanded(
            child: StreamBuilder(
                stream: vaultStreamController.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const CircularProgressIndicator();
                  else if (snapshot.hasData) {
                    var data = snapshot.data;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              double percent = 0.9;
                              Color progressColor = colorlib.progress;
                              return InkWell(
                                onTap: () {
                                  widget.detailPage!(data[index]['id'], 0);
                                },
                                child: ListApp(
                                    scrw: scrw,
                                    scrh: scrh,
                                    imageUrl: data[index]['Application']['imageurl'],
                                    appName: data[index]['vault_name'],
                                    appPassword: data[index]['saved_password'],
                                    percent: percent,
                                    progressColor: progressColor),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else
                    return CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
  }
}

class ListApp extends StatelessWidget {
  const ListApp({
    super.key,
    required this.scrw,
    required this.scrh,
    required this.imageUrl,
    required this.appName,
    required this.appPassword,
    required this.percent,
    required this.progressColor,
  });

  final double scrw;
  final double scrh;
  final String imageUrl;
  final String appName;
  final String appPassword;
  final double percent;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrw * 90,
      height: scrh * 10,
      child: Row(
        children: [
          GFAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          Spacer(),
          Container(
            width: scrw * 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(appPassword),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                LinearPercentIndicator(
                  padding: EdgeInsets.all(0),
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: progressColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.scrw,
    required this.scrh,
    required this.count,
    required this.name,
    required this.backColor,
    required this.borderColor,
  });

  final double scrw;
  final double scrh;
  final int count;
  final String name;
  final Color backColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: scrw * 15,
      height: scrh * 8,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 3, color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.raleway(fontSize: 18, letterSpacing: 1.5, color: borderColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          Text(
            name,
            style: GoogleFonts.raleway(
              fontSize: 12,
              letterSpacing: 2,
              color: borderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
