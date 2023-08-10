import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_ping_project/settings/colorlib.dart';

import 'package:pass_ping_project/settings/urlrefs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token, required this.thrower});
  final token;
  final thrower;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamController profileStreamController = new StreamController.broadcast();

  Future<dynamic> getPofileData() async {
    var data = await http.get(linkref.parser(linkref.main, linkref.userGetdata), headers: {
      "Authorization": "${widget.token}",
    }).timeout(Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    try {
      var jsonResult = json.decode(data.body);
      setState(() {
        // vaultSearchData = jsonResult['data'];
        profileStreamController.sink.add(jsonResult['data']);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPofileData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlPViCqVyGRxdQtmHT-5rBlQoa1XJsMwkOdQ3A-hEWfkYMRLG-S-LRYCLcGteHqbSF4Kk&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return StreamBuilder(
        stream: profileStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const CircularProgressIndicator();
          else if (snapshot.hasData) {
            var data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'PROFILE',
                    style: GoogleFonts.lato(letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 24, color: colorlib.primer),
                  ),
                  SizedBox(
                    height: scrh * 5,
                  ),
                  GFAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(
                    height: scrh,
                  ),
                  Text(
                    data['username'],
                    style: GoogleFonts.raleway(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16, color: colorlib.black),
                  ),
                  Text(
                    '+62813458',
                    style: GoogleFonts.raleway(letterSpacing: 1.5, fontSize: 16, color: colorlib.black),
                  ),
                  SizedBox(
                    height: scrh * 2,
                  ),
                  Container(
                    width: scrw * 20,
                    child: GFButton(
                      fullWidthButton: true,
                      onPressed: () {},
                      text: "Edit Profile",
                      type: GFButtonType.solid,
                      blockButton: true,
                    ),
                  ),
                  SizedBox(
                    height: scrh * 5,
                  ),
                  Text(
                    'INFORMATION',
                    style: GoogleFonts.lato(letterSpacing: 3, fontWeight: FontWeight.bold, fontSize: 20, color: colorlib.black),
                  ),
                  SizedBox(
                    height: scrh,
                  ),
                  Row(
                    children: [
                      Text(
                        'Security',
                        style: GoogleFonts.raleway(letterSpacing: 0.5, color: colorlib.black),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  SizedBox(
                    height: scrh * 0.5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Trusted Device',
                        style: GoogleFonts.raleway(letterSpacing: 0.5, color: colorlib.black),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  SizedBox(
                    height: scrh * 0.5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Backup',
                        style: GoogleFonts.raleway(letterSpacing: 0.5, color: colorlib.black),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  SizedBox(
                    height: scrh * 0.5,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        width: scrw * 20,
                        child: GFButton(
                          fullWidthButton: true,
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove('jwt');
                            // Navigator.pushNamed(context, '/auth');
                            widget.thrower!(11);
                          },
                          text: "Logout",
                          type: GFButtonType.outline,
                          blockButton: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else
            return const CircularProgressIndicator();
        });
  }
}
