import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class BePremiumUser extends StatefulWidget {
  const BePremiumUser({Key? key}) : super(key: key);

  @override
  State<BePremiumUser> createState() => _BePremiumUserState();
}

class _BePremiumUserState extends State<BePremiumUser> {
  final Color _yaziTipiRengi = Color(0xffE4EBDE);

  @override
  Widget build(BuildContext context) {
    late var _appHeaderText =
        AppLocalizations.of(context)!.appHeader.toString();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/kiwiLogo.png",
                            height: 100,
                            width: 100,
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              _appHeaderText,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.philosopher(
                                  fontSize: 32, color: _yaziTipiRengi),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5,
                child: Container(
                  height: 40,
                  child: IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
