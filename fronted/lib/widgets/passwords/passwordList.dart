import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordListWidget extends StatelessWidget {
  const PasswordListWidget({
    super.key,
    required this.scrw,
    required this.scrh,
    required this.data,
    required this.detailPage,
  });

  final imageNon = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHap273IICnf0GtkuZBeD73LgNOPpaL-9Jpha-Fy1feg&s';
  final double scrw;
  final double scrh;
  final dynamic data;
  final Function? detailPage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        detailPage!(data['id'], 1);
      },
      child: Container(
        width: scrw * 90,
        height: scrh * 10,
        child: Row(
          children: [
            GFAvatar(
              backgroundImage: NetworkImage(data['Application']['imageurl'] ?? imageNon),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DefaultTextStyle(
                style: GoogleFonts.lato(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['vault_name'],
                      style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                    ),
                    Text(data['saved_password']),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data['saved_password'])).then((value) => //only if ->
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('password have been copied to clipboard'))));
              },
              icon: Icon(Icons.copy_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
