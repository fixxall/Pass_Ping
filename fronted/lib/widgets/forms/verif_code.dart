import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerifCodePage extends StatefulWidget {
  VerifCodePage(this.token);
  final token;

  @override
  State<VerifCodePage> createState() => _VerifCodePageState();
}

class _VerifCodePageState extends State<VerifCodePage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.lato(
        fontSize: 20,
        color: const Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Material(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: scrh * 20,
              width: scrw * 90,
              decoration: BoxDecoration(
                border: Border.all(width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Enter Verification Code'),
                    SizedBox(
                      height: 16,
                    ),
                    Pinput(
                      keyboardType: TextInputType.number,
                      length: 6,
                      controller: controller,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      separator: const SizedBox(width: 16),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                              offset: Offset(0, 3),
                              blurRadius: 16,
                            )
                          ],
                        ),
                      ),
                      // onClipboardFound: (value) {
                      //   debugPrint('onClipboardFound: $value');
                      //   controller.setText(value);
                      // },
                      showCursor: true,
                      cursor: cursor,
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GFButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home', arguments: widget.token);
                },
                text: "Continue",
                type: GFButtonType.outline),
          ),
        ],
      ),
    );
  }
}
