import 'package:flutter/material.dart';
import 'package:rent_app/const.dart';
import 'package:ripple_effect/ripple_effect.dart';
import 'custom_map_user_card.dart';

class CustomMapUserMarker extends StatelessWidget {
  final String imageUrl;
  // The docId in location collection is same as Uid of user
  final String docId;

  const CustomMapUserMarker({Key key, this.imageUrl, this.docId}) : super(key: key);

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => CustomMapUserCard(
        uid: this.docId,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.fastLinearToSlowEaseIn;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(context, _createRoute());
      },
      child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    this.imageUrl ?? Constants().defaultImageUrl,
                  )))),
    );
  }
}
