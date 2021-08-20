
import 'package:flutter/material.dart';
import 'package:fluttermovie/cons.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'MovieApps',
        style: TextStyle(fontSize: 20, color: kBackround),
      ),
      centerTitle: true,
      leading: Icon(
        Icons.menu,
        size: 18,
        color: kBackround,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(24),
          child: Icon(Icons.notifications, color: kBackround, size: 18,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
