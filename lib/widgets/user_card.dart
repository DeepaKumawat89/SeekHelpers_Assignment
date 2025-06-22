//------------------------------------ Imports ------------------------------------//
import 'package:flutter/material.dart';
import '../Models/user_model.dart';

//------------------------------------ User Card Widget ------------------------------------//
class UserCard extends StatelessWidget {
  //------------------------------------ Properties ------------------------------------//
  final User user;

  //------------------------------------ Constructor ------------------------------------//
  const UserCard({required this.user});

  //------------------------------------ Build Method ------------------------------------//
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    //------------------------------------ Card UI ------------------------------------//
    return Material(
      color: Colors.transparent,
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: isTablet ? 8.0 : 4.0,
          horizontal: isTablet ? 12.0 : 8.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          //------------------------------------ List Tile Content ------------------------------------//
          child: ListTile(
            contentPadding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              user.email,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.black54,
              ),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
                size: isTablet ? 24 : 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
