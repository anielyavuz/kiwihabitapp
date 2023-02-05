import 'package:flutter/material.dart';

// class ButtonlessPopUp extends StatefulWidget {
//   final String input;
//   const ButtonlessPopUp({ Key? key , this.input}) : super(key: key);

//   @override
//   _ButtonlessPopUpState createState() => _ButtonlessPopUpState();
// }

// class _ButtonlessPopUpState extends State<ButtonlessPopUp> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

class ButtonlessPopUp extends StatefulWidget {
  final String input; //Note: statefull'a parametre göndermek için gerekli
  final double fontSize;
  const ButtonlessPopUp({Key? key, required this.input, required this.fontSize})
      : super(key: key); //Note: statefull'a parametre göndermek için gerekli
  @override
  State<StatefulWidget> createState() => ButtonlessPopUpState();
}

class ButtonlessPopUpState extends State<ButtonlessPopUp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  widget.input,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: widget.fontSize),
                ), //Note: statefull'a parametre göndermek için gerekli
              ),
            ),
          ),
        ),
      ),
    );
  }
}
