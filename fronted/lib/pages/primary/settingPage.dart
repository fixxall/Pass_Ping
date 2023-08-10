import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.token, required this.thrower});

  final Function? thrower;

  final token;
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Text('Profile'),
              Spacer(),
              IconButton(
                onPressed: () {
                  widget.thrower!(2);
                },
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          // Row(
          //   children: [
          //     Text('Permissions'),
          //     Spacer(),
          //     Icon(Icons.arrow_forward_ios_rounded),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Text('Sync'),
          //     Spacer(),
          //     GFToggle(
          //       onChanged: (val) {},
          //       value: true,
          //       type: GFToggleType.ios,
          //     )
          //   ],
          // ),
          // Row(
          //   children: [
          //     Text('Autofill'),
          //     Spacer(),
          //     GFToggle(
          //       onChanged: (val) {},
          //       value: true,
          //       type: GFToggleType.ios,
          //     ),
          //   ],
          // ),
          Row(
            children: [
              Text('About'),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text('Help'),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text('Version'),
              Spacer(),
              Text('1.1.0'),
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
