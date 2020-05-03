import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHeader extends StatefulWidget {
  final String image;
  final String textTop;
  final String textBottom;

  const MyHeader({
    Key key,
    this.image,
    this.textTop,
    this.textBottom,
  }) : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, top: 50, right: 20),
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.lightGreen[900],
            Colors.green,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: SizedBox(
                    height: 280,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        widget.image,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 30,
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: FittedBox(
                      child: Text(
                        "${widget.textTop} \n${widget.textBottom}",
                        style: kHeadingTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
