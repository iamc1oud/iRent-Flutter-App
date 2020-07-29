import 'package:flutter/material.dart';
import 'package:rent_app/const.dart';
import 'custom_map_user_card.dart';

class CustomMapUserMarker extends StatelessWidget {
  final String imageUrl;
  // The docId in location collection is same as Uid of user
  final String docId;

  const CustomMapUserMarker({Key key, this.imageUrl, this.docId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showDialog(
        //   barrierDismissible: true,
        //   context: context,
        //   builder: (context) {
        //     print("Doing working");
        //     return CustomMapUserCard();
        //   },
        // );

        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomMapUserCard(
          uid: this.docId,
        )));
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
